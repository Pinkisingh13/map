import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    try {
      // Checking if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception("Location services are disabled.");

      // Check and request for location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions denied.");
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw LocationException(
          "Location permissions are permanently denied. Please enable them from app settings.",
        );
      }
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    } catch (e) {
      debugPrint("Location Eror: $e");
      throw LocationException("Failed to get current location. ${e.toString()}");
    }
  }
}


class LocationException implements Exception {
  final String message;
  LocationException(this.message);

  @override
  String toString() => message;
}