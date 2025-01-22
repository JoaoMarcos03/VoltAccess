import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/rental_service.dart';
import '../services/car_service.dart';

class CarRentalScreen extends StatelessWidget {
  final String carId;

  const CarRentalScreen({super.key, required this.carId});

  String formatDuration(int seconds) {
    final hours = (seconds / 3600).floor();
    final minutes = ((seconds % 3600) / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showRentalPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          'Citroën AMI 5',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '€0.30 per minute\nDaily cap: €20.00',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {},
                  child: const Text('Start Rental', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rentalService = Provider.of<RentalService>(context);
    final carService = Provider.of<CarService>(context);
    final carDetails = carService.getCarById(carId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          carDetails?['name'] ?? 'Rent Car',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.grey[200],
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      carDetails?['name'] ?? '',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      rentalService.isRenting ? 'Rental In Progress' : 'Ready to Start',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    if (rentalService.isRenting) ...[
                      Text(
                        formatDuration(rentalService.elapsedSeconds),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '€${rentalService.currentCost.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),
                      ),
                    ],
                    const SizedBox(height: 20),
                    if (!rentalService.isRenting)
                      ElevatedButton(
                        onPressed: () => _showRentalPopup(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Rent Car', style: TextStyle(color: Colors.white)),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
