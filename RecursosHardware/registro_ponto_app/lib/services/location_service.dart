import 'package:geolocator/geolocator.dart';
import '../config/app_config.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Serviço de localização desativado.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissão negada permanentemente.');
    }
    return await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
  }

  double calculateDistance(double currentLat, double currentLng) {
    return Geolocator.distanceBetween(
      currentLat, currentLng,
      AppConfig.workplaceLatitude, AppConfig.workplaceLongitude,
    );
  }
}