import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickupPointModel {
  final int id;
  final LatLng location;
  final String timeSlot;
  final int inventory;

  PickupPointModel({required this.id, required this.location, required this.timeSlot, required this.inventory});
  
}