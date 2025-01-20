import 'dart:io';

class RideHistory {
  final String carId;
  final String carName;
  final DateTime startTime;
  final DateTime endTime;
  final double cost;
  final Map<String, File> preRidePhotos;
  final Map<String, File> postRidePhotos;

  RideHistory({
    required this.carId,
    required this.carName,
    required this.startTime,
    required this.endTime,
    required this.cost,
    required this.preRidePhotos,
    required this.postRidePhotos,
  });

  int get durationInSeconds => endTime.difference(startTime).inSeconds;

  Map<String, dynamic> toJson() {
    return {
      'carId': carId,
      'carName': carName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'cost': cost,
      // Note: photos would need special handling for persistence
    };
  }
}
