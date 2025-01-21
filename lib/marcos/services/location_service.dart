import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService extends ChangeNotifier {
  LatLng? currentLocation;
  final Location _location = Location();

  Future<void> getCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      notifyListeners();
    } catch (e) {
      print('Error getting location: $e');
    }
  }
}