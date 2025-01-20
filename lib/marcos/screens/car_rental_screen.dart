
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

  @override
  Widget build(BuildContext context) {
    final rentalService = Provider.of<RentalService>(context);
    final carService = Provider.of<CarService>(context);
    final carDetails = carService.getCarById(carId);

    return Scaffold(
      appBar: AppBar(
        title: Text(carDetails?['name'] ?? 'Rent Car'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      carDetails?['name'] ?? '',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      rentalService.isRenting ? 'Rental In Progress' : 'Ready to Start',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    if (rentalService.isRenting) ...[
                      Text(
                        formatDuration(rentalService.elapsedSeconds),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '€${rentalService.currentCost.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                    const SizedBox(height: 20),
                    if (!rentalService.isRenting)
                      ElevatedButton(
                        onPressed: () => rentalService.startRental(carId),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Start Rental'),
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          final cost = rentalService.endRental();
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Rental Complete'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Duration: ${formatDuration(rentalService.elapsedSeconds)}'),
                                  Text('Total cost: €${cost.toStringAsFixed(2)}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('End Rental'),
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
