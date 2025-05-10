import 'package:geolocator/geolocator.dart';

class LocationService {


Future<Position> getCurrentLocation() async {

bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return throw Exception('Location services are disabled.');
  }
   
  //Check and request for location permission
 LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return throw Exception('Location permissions are denied');
    }
  }
  
  // If permission is denied for forever
  if (permission == LocationPermission.deniedForever) {
    return throw Exception(
      'Location permissions are permanently denied, we cannot request permissions. Please enable them from app settings.');
  }
  return await Geolocator.getCurrentPosition();
 
}
}