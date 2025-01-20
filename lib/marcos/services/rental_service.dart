import 'dart:async';
import 'package:flutter/foundation.dart';
import 'pricing_service.dart';

/// Manages the car rental state and timing functionality.
/// Handles starting/stopping rentals and calculates costs in real-time.
class RentalService extends ChangeNotifier {
  final PricingService _pricingService = PricingService();
  
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
      _cleanup();
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
