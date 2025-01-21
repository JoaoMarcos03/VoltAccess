import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/rental_service.dart';
import '../services/car_service.dart';

class RentalOverlay extends StatelessWidget {
  final String carId;

  const RentalOverlay({super.key, required this.carId});

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

    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  carDetails?['name'] ?? '',
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
                ] else ...[
                  const Text('€0.30 per minute'),
                  const Text('Daily cap: €20.00'),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!rentalService.isRenting)
                      ElevatedButton(
                        onPressed: () => rentalService.startRental(carId),
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
                                children: [
                                  Text('Duration: ${formatDuration(rentalService.elapsedSeconds)}'),
                                  Text('Total cost: €${cost.toStringAsFixed(2)}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close dialog
                                    Navigator.pop(context); // Close overlay
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('End Rental'),
                      ),
                    const SizedBox(width: 10),
                    if (!rentalService.isRenting)
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

