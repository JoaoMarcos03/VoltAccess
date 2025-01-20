import 'dart:async';
import 'package:flutter/foundation.dart';
import 'pricing_service.dart';
import '../models/ride_history.dart';
import 'car_service.dart';
import 'photo_service.dart';

/// Manages the car rental state and timing functionality.
/// Handles starting/stopping rentals and calculates costs in real-time.
class RentalService extends ChangeNotifier {
  final PricingService _pricingService = PricingService();
  final List<RideHistory> _rideHistory = [];
  final CarService _carService;
  final PhotoService _photoService;
  
  // Constructor injection
  RentalService(this._carService, this._photoService);
  
  // Rental state
  bool _isRenting = false;
  String? _currentCarId;
  DateTime? _startTime;
  Timer? _timer;
  int _elapsedSeconds = 0;

  // Public getters
  bool get isRenting => _isRenting;
  String? get currentCarId => _currentCarId;
  int get elapsedSeconds => _elapsedSeconds;
  List<RideHistory> get rideHistory => List.unmodifiable(_rideHistory);
  
  /// Calculates the current cost based on elapsed time and membership type
  double get currentCost => _pricingService.calculateRentalCost(
    (_elapsedSeconds / 60).ceil(),
    'pay-as-you-go', // TODO: Implement membership types
  );

  /// Starts a new rental for the specified car
  /// Initializes timer and updates rental state
  void startRental(String carId) {
    if (!_isRenting) {
      _isRenting = true;
      _currentCarId = carId;
      _startTime = DateTime.now();
      _elapsedSeconds = 0;
      _startTimer();
      notifyListeners();
    }
  }

  /// Ends the current rental and returns the final cost
  /// Cleans up timer and rental state
  double endRental() {
    if (_isRenting) {
      _isRenting = false;
      _timer?.cancel();
      final cost = currentCost;
      
      // Get car details with null check
      final car = _carService.getCarById(_currentCarId!);
      final carName = car?['name'] ?? 'Unknown Car';
      
      // Save ride history with photos
      _rideHistory.add(RideHistory(
        carId: _currentCarId!,
        carName: carName,  // Use the retrieved car name
        startTime: _startTime!,
        endTime: DateTime.now(),
        cost: cost,
        preRidePhotos: _photoService.getPreRidePhotos(),
        postRidePhotos: _photoService.getPostRidePhotos(),
      ));
      
      // Clear photos for next ride
      _photoService.clearPhotos();
      
      _cleanup();
      notifyListeners();
      return cost;
    }
    return 0;
  }

  /// Sets up a periodic timer to update elapsed time every second
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_startTime != null) {
        _elapsedSeconds = DateTime.now().difference(_startTime!).inSeconds;
        notifyListeners();
      }
    });
  }

  /// Cleans up rental state
  void _cleanup() {
    _elapsedSeconds = 0;
    _currentCarId = null;
    _startTime = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
