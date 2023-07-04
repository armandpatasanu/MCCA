import 'package:fitxkonnect/services/geolocator_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class AppBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();

  Position? currentLocation;

  AppBloc() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners();
  }
}
