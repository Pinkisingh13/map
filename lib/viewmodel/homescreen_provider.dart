import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/model/pickup_point_model.dart';
import 'package:map/services/location_service.dart';

class HomeScreenProvider extends ChangeNotifier {
  LatLng? currentLocation;
  final warehouseLocation = LatLng(26.5118, 90.4964);
  final List<PickupPointModel> pickups = [
    PickupPointModel(
      id: 1,
      location: LatLng(26.5030, 90.5536),
      timeSlot: "9AM-10AM",
      inventory: 5,
    ),
    PickupPointModel(
      id: 2,
      location: LatLng(26.4995, 90.5355),
      timeSlot: "9AM-10AM",
      inventory: 5,
    ),
    PickupPointModel(
      id: 3,
      location: LatLng(26.5000, 90.5400),
      timeSlot: "9AM-10AM",
      inventory: 5,
    ),
  ];

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  Future<void> initialize() async {
    final position = await LocationService().getCurrentLocation();
    currentLocation = LatLng(position.latitude, position.longitude);

    _addMarker();
    notifyListeners();
  }
  
  // Added Markers: Rider -> Pickups Points -> Warehouse
  void _addMarker() {
    // Marker -> Rider
    markers.add(
      Marker(
        markerId: MarkerId('rider'),
        position: currentLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: "Rider"),
      ),
    );

    // Marker -> Pickup Points
    for (var pickup in pickups) {
      markers.add(
        Marker(
          markerId: MarkerId('pickup_${pickup.id}'),
          position: pickup.location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: "Pickup ${pickup.id}"),
        ),
      );
    }

    // Marker -> Warehouse
    markers.add(
      Marker(
        markerId: MarkerId("Warehouse"),
        position: warehouseLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        infoWindow: InfoWindow(title: "Warehouse"),
      ),
    );
  }
}
