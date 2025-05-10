import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/services/location_service.dart';

class HomeScreenProvider extends ChangeNotifier {
   LatLng? currentLocation; 
   

  Future<void> initialize() async{
  final position = await LocationService().getCurrentLocation(); 
  currentLocation = LatLng(position.latitude, position.longitude);
  notifyListeners();
  }
}