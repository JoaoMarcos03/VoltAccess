import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../marcos/services/rental_service.dart';
import '../marcos/models/ride_history.dart';

class RideHistoryPage extends StatelessWidget {
  const RideHistoryPage({super.key});

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _showRideDetails(BuildContext context, RideHistory ride) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: Text(ride.carName),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${ride.startTime.toLocal().toString().split('.')[0]}'),
                    Text('Duration: ${_formatDuration(ride.endTime.difference(ride.startTime))}'),
                    Text('Cost: €${ride.cost.toStringAsFixed(2)}'),
                    const Divider(),
                    _buildPhotoSection('Pre-Ride Photos', ride.preRidePhotos),
                    const Divider(),
                    _buildPhotoSection('Post-Ride Photos', ride.postRidePhotos),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection(String title, Map<String, File> photos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (photos.isEmpty)
          const Text('No photos available')
        else
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: photos.entries.map((entry) => InkWell(
              onTap: () => _showFullScreenPhoto(entry.value),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  entry.value,
                  fit: BoxFit.cover,
                ),
              ),
            )).toList(),
          ),
      ],
    );
  }

  void _showFullScreenPhoto(File photo) {
    showDialog(
      context: globalKey.currentContext!,
      builder: (context) => Dialog(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Image.file(photo),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  static final GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride History'),
      ),
      body: Consumer<RentalService>(
        builder: (context, rentalService, child) {
          final rides = rentalService.rideHistory;
          
          if (rides.isEmpty) {
            return const Center(
              child: Text('No rides yet', 
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(ride.carName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${ride.startTime.toLocal().toString().split('.')[0]}'),
                      Text('Duration: ${_formatDuration(ride.endTime.difference(ride.startTime))}'),
                      Text('Cost: €${ride.cost.toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showRideDetails(context, ride),
                ),
              );
            },
          );
        },
      ),
    );
  }
}