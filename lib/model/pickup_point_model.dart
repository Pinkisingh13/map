import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickupPointModel {
  final int id;
  final LatLng location;
  final String timeSlot;
  final int inventory;
  final String address;
  final String specialInstructions;

  PickupPointModel({
    required this.id,
    required this.location,
    required this.timeSlot,
    required this.inventory,
    this.address = "",
    this.specialInstructions = "",

  });
}



class RiderToWarehouseModel {
  final String distance;
  final String duration;

  RiderToWarehouseModel({
    required this.distance,
    required this.duration,
  });
}
