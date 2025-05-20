import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:map/model/pickup_point_model.dart';
import 'package:map/services/location_service.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreenProvider extends ChangeNotifier {
  LatLng? currentLocation;
  PickupPointModel? selectedPickup;
  RiderToWarehouseModel? selectedRider;
  String? distance;
  String? duration;
  final warehouseLocation = LatLng(26.5118, 90.4964);
  final apiKey = dotenv.env['GOOGLE_MAP_API_KEY'];
  List<PickupPointModel> pickups = [
    PickupPointModel(
      id: 1,
      location: LatLng(26.5030, 90.5536),
      timeSlot: "9AM-10AM",
      inventory: 5,
      specialInstructions: "There is no need to pay parking fee here",
    ),
    PickupPointModel(
      id: 2,
      location: LatLng(26.4995, 90.5355),
      timeSlot: "10AM-11AM",
      inventory: 5,
      specialInstructions: "There is no need to pay parking fee here",
    ),
    PickupPointModel(
      id: 3,
      location: LatLng(26.5000, 90.5400),
      timeSlot: "11AM-12PM",
      inventory: 5,
      specialInstructions: "There is no need to pay parking fee here",
    ),
  ];

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  /// Checking Location Permission, showing markers and adding routes
  Future<void> initialize() async {
    try {
      final position = await LocationService().getCurrentLocation();
      currentLocation = LatLng(position.latitude, position.longitude);

      _addMarkers();
      await _drawPolyline();
      await calculateDistance();
    } on LocationException catch (e) {
      debugPrint("Location Exception: ${e.message}");
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint("Map initialization failed: $e, $stackTrace");
      }
    }
    notifyListeners();
  }

  /// set the selected pickup and fetches its address using reverse geocoding
  void selectPickup(PickupPointModel? pickup) async {
    if (pickup == null) {
      selectedPickup = null;
    } else {
      final address = await getAddressFromLatLng(pickup.location);
      selectedPickup = PickupPointModel(
        id: pickup.id,
        location: pickup.location,
        timeSlot: pickup.timeSlot,
        inventory: pickup.inventory,
        address: address,
        specialInstructions: pickup.specialInstructions,
      );
    }
    notifyListeners();
  }

  /// Converting lat longitude in a string based address
  Future<String> getAddressFromLatLng(LatLng position) async {
    try {
      final places = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      debugPrint("Address Information: $places");

      if (places.isNotEmpty) {
        final place = places.first;
        return [
          place.street,
          place.subLocality,
          place.locality,
          place.postalCode,
        ].where((s) => s != null && s.isNotEmpty).join(', ');
      }
      return 'Address not available';
    } catch (e) {
      debugPrint('Geocoding error: $e');
      return 'Could not fetch address';
    }
  }

  /// Calculating distance
  Future<void> calculateDistance() async {
    try {
      if (currentLocation == null || apiKey == null) return;
      final origin =
          "${currentLocation?.latitude}, ${currentLocation?.longitude}";
      final destination =
          "${warehouseLocation.latitude}, ${warehouseLocation.longitude}";

      final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/distancematrix/json"
        "?origins=$origin"
        "&destinations=$destination"
        "&mode=driving"
        "&key=$apiKey",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        debugPrint("Response ==> ${response.body}");
        final data = json.decode(response.body);
        final element = data['rows'][0]['elements'][0];

        distance = element['distance']['text'];
        duration = element['duration']['text'];
      } else {
        debugPrint("Distance Matrix API error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching distance/time: $e");
    }
    notifyListeners();
  }

  void selectRider(RiderToWarehouseModel? warehouse) async {
    if (warehouse == null) {
      selectedRider = null;
    } else {
      selectedRider = warehouse;
    }
    notifyListeners();
  }

  /// Adds map markers for rider, pickups, and warehouse
  void _addMarkers() {
    // Rider Marker
    markers.add(
      Marker(
        markerId: const MarkerId('rider'),
        position: currentLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        onTap: () {
          selectedRider = RiderToWarehouseModel(
            distance: distance!,
            duration: duration!,
          );
          notifyListeners();
        },

        infoWindow: InfoWindow(title: "Rider"),
      ),
    );

    // Pickup Markers
    for (final pickup in pickups) {
      markers.add(
        Marker(
          markerId: MarkerId('pickup_${pickup.id}'),
          position: pickup.location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () => selectPickup(pickup),
          infoWindow: InfoWindow(title: "Pickup ${pickup.id}"),
        ),
      );
    }

    // Warehouse Marker
    markers.add(
      Marker(
        markerId: const MarkerId('warehouse'),
        position: warehouseLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: "Warehouse"),
      ),
    );
  }

  /// Draws a polyline route from rider location -> pickups -> warehouse
  Future<void> _drawPolyline() async {
    if (currentLocation == null) return;

    final polylinePoints = PolylinePoints();
    final allStops = [
      currentLocation!,
      ...pickups.map((e) => e.location),
      warehouseLocation,
    ];
    List<LatLng> polylineCoords = [];

    for (int i = 0; i < allStops.length - 1; i++) {
      final origin = PointLatLng(allStops[i].latitude, allStops[i].longitude);
      final destination = PointLatLng(
        allStops[i + 1].latitude,
        allStops[i + 1].longitude,
      );

      print("Api Key : $apiKey");
       final waypoints = pickups
          .map((p) => "${p.location.latitude},${p.location.longitude}")
          .join('|');
      final result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: apiKey,
        request: PolylineRequest(
          origin: origin,
           wayPoints: [
            PolylineWayPoint(location: waypoints),
           ],
          alternatives: true,
          destination: destination,
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        final segmentCoords =
            result.points.map((p) => LatLng(p.latitude, p.longitude)).toList();

        polylines.add(
          Polyline(
            polylineId: PolylineId("segment_$i"),
            color: Colors.blue,
            width: 4,
            points: segmentCoords,
          ),
        );
      } else if (result.errorMessage != null) {
        debugPrint("Route error: ${result.errorMessage}");
      }
    }

    // Add one combined polyline for entire trip
    if (polylineCoords.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          points: polylineCoords,
          color: Colors.blue,
          width: 5,
        ),
      );
      notifyListeners();
    }
  }

  /// Navigate to Google Maps with full route: current -> pickups -> warehouse
  Future<void> launchNavigation() async {
    try {
      if (currentLocation == null) {
        throw Exception("Current Location Not Available");
      }

      // Start (origin), waypoints (pickups), end (warehouse)
      final origin =
          "${currentLocation!.latitude},${currentLocation!.longitude}";
      final destination =
          "${warehouseLocation.latitude},${warehouseLocation.longitude}";

      // Waypoints (pickup locations as a single string, separated by |)
      final waypoints = pickups
          .map((p) => "${p.location.latitude},${p.location.longitude}")
          .join('|');

      final url = Uri.parse(
        "https://www.google.com/maps/dir/?api=1"
        "&origin=$origin"
        "&destination=$destination"
        "&waypoints=$waypoints"
        "&travelmode=driving",
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw Exception("Error in launching navigation");
      }
    } catch (e) {
      debugPrint("error in navigation to google map: $e");
    }
  }
}
