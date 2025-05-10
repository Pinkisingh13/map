import 'package:flutter/material.dart';
import 'package:map/services/location_service.dart';

class HomeScreenProvider extends ChangeNotifier {
  late LocationService locationService;

  void initialize(){
  locationService.getCurrentLocation();
  }
}