import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Manages car locations and availability.
/// Handles distance calculations and car marker management.
class CarService extends ChangeNotifier {
  // Constants
  static const double MAX_RENTAL_DISTANCE = 50.0; // meters
  static const double EARTH_RADIUS = 6371000.0; // meters

  // Available cars data
  static final List<Map<String, dynamic>> _carLocations = [
    {
      'id': 'car_1',
      'name': 'Citroën AMI 1',
      'lat': 41.007850,
      'lng': -8.636281,
    },
    {
      'id': 'car_2',
      'name': 'Citroën AMI 2',
      'lat': 41.008050,
      'lng': -8.636481,
    },
    {
      'id': 'car_3',
      'name': 'Citroën AMI 3',
      'lat': 41.005127198462105,
      'lng': -8.633992917452346,
    },
    {
      'id': 'car_4',
      'name': 'Citroën AMI 4',
      'lat': 41.007831134544766,
      'lng': -8.636033275819013,
    },
	{
      'id': 'car_5',
      'name': 'Citroën AMI 5',
      'lat': 41.119265704031406,
      'lng': -8.622223922180122,
    },
	{
      'id': 'car_6',
      'name': 'Citroën AMI 6',
      'lat': 41.11973531818157,
      'lng': -8.623497826735035,
    },
	{
      'id': 'car_7',
      'name': 'Citroën AMI 7',
      'lat': 41.05182132576213,
      'lng': -8.61397927499262,
    },
  ];

  // Active markers on the map
  Set<Marker> markers = {};

  // Getters
  List<Map<String, dynamic>> get carLocations => _carLocations;

  /// Initializes car markers on the map
  void initializeMockCars() {
    markers = _carLocations.map((car) => _createCarMarker(car)).toSet();
    notifyListeners();
  }

  /// Creates a marker for a specific car
  Marker _createCarMarker(Map<String, dynamic> car) {
    return Marker(
      markerId: MarkerId(car['id']),
      position: LatLng(car['lat'], car['lng']),
      infoWindow: InfoWindow(
        title: car['name'],
        snippet: '€0.30/minute',
      ),
    );
  }

  /// Checks if a car is within rental distance of the user
  bool isCarNearby(LatLng userLocation, LatLng carLocation) {
    return calculateDistance(userLocation, carLocation) <= MAX_RENTAL_DISTANCE;
  }

  /// Calculates distance between two points using the Haversine formula
  double calculateDistance(LatLng point1, LatLng point2) {
    final lat1 = point1.latitude * pi / 180;
    final lat2 = point2.latitude * pi / 180;
    final dLat = (point2.latitude - point1.latitude) * pi / 180;
    final dLon = (point2.longitude - point1.longitude) * pi / 180;

    final a = sin(dLat/2) * sin(dLat/2) +
              cos(lat1) * cos(lat2) *
              sin(dLon/2) * sin(dLon/2);
    final c = 2 * atan2(sqrt(a), sqrt(1-a));
    
    return EARTH_RADIUS * c;
  }

  /// Retrieves car details by ID
  Map<String, dynamic>? getCarById(String carId) {
    try {
      return _carLocations.firstWhere((car) => car['id'] == carId);
    } catch (_) {
      return null;
    }
  }
}