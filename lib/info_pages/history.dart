import 'package:flutter/material.dart';

class RideHistoryPage extends StatelessWidget {
  const RideHistoryPage({super.key});

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  double _calculateCost(Duration duration) {
    const double ratePerMinute = 0.30;
    const double dailyCap = 20.00;
    double totalCost = duration.inMinutes * ratePerMinute;
    return totalCost > dailyCap ? dailyCap : totalCost;
  }

  void _showRideDetails(BuildContext context, Ride ride) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: Text(ride.carName, style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.black,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 16),
              Text('Date: ${ride.startTime.toLocal().toString().split('.')[0]}',
                  style: const TextStyle(color: Colors.white)),
              Text('Duration: ${_formatDuration(ride.endTime.difference(ride.startTime))}',
                  style: const TextStyle(color: Colors.white)),
              Text('Cost: €${_calculateCost(ride.endTime.difference(ride.startTime)).toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rides = [
      Ride(
        carName: 'Citroën Ami',
        startTime: DateTime(2024, 4, 10, 14, 30),
        endTime: DateTime(2024, 4, 10, 15, 8),
      ),
      Ride(
        carName: 'Citroën Ami',
        startTime: DateTime(2024, 5, 8, 9, 15),
        endTime: DateTime(2024, 5, 8, 9,37),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Ride History', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: rides.isEmpty
          ? const Center(
              child: Text('No rides yet', style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: rides.length,
              itemBuilder: (context, index) {
                final ride = rides[index];
                return Card(
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(ride.carName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${ride.startTime.toLocal().toString().split('.')[0]}'),
                        Text('Duration: ${_formatDuration(ride.endTime.difference(ride.startTime))}'),
                        Text('Cost: €${_calculateCost(ride.endTime.difference(ride.startTime)).toStringAsFixed(2)}'),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.black),
                    onTap: () => _showRideDetails(context, ride),
                  ),
                );
              },
            ),
    );
  }
}

class Ride {
  final String carName;
  final DateTime startTime;
  final DateTime endTime;

  Ride({
    required this.carName,
    required this.startTime,
    required this.endTime,
  });
}
