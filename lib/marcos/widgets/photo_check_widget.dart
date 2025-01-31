import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/photo_service.dart';

class PhotoCheckWidget extends StatelessWidget {
  final bool isPreRide;
  final Function onComplete;

  const PhotoCheckWidget({
    super.key,
    required this.isPreRide,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final photoService = Provider.of<PhotoService>(context);
    final photos = isPreRide ? photoService.preRidePhotos : photoService.postRidePhotos;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPreRide ? 'Pre-Ride Check' : 'Post-Ride Check'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              children: [
                _buildPhotoItem(context, 'Front', 'front', photos, photoService),
                _buildPhotoItem(context, 'Back', 'back', photos, photoService),
                _buildPhotoItem(context, 'Left Side', 'left', photos, photoService),
                _buildPhotoItem(context, 'Right Side', 'right', photos, photoService),
              ],
            ),
          ),
          Padding(
  padding: const EdgeInsets.all(16),
  child: ElevatedButton(
    onPressed: (isPreRide ? photoService.arePreRidePhotosComplete()
                          : photoService.arePostRidePhotosComplete())
        ? () => onComplete()
        : null,
    style: ElevatedButton.styleFrom(
      backgroundColor: (isPreRide ? photoService.arePreRidePhotosComplete()
                                  : photoService.arePostRidePhotosComplete())
          ? Colors.black // Czarny, gdy aktywny
          : Colors.grey[700], // Szary, gdy nieaktywny
      foregroundColor: Colors.white, // Biały tekst
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32), // Większy padding dla lepszego wyglądu
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bardziej zaokrąglone rogi jak w "Start Rental"
      ),
      elevation: 4, // Lekki cień, żeby wyglądało lepiej
    ),
    child: Text(
      isPreRide ? 'Start Ride' : 'Complete Ride',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  ),
),

        ],
      ),
    );
  }

  Widget _buildPhotoItem(BuildContext context, String label, String key,
      Map<String, File?> photos, PhotoService photoService) {
    return Card(
      child: InkWell(
        onTap: () async {
          final photo = await photoService.takePhoto();
          if (photo != null) {
            if (isPreRide) {
              photoService.preRidePhotos[key] = photo;
            } else {
              photoService.postRidePhotos[key] = photo;
            }
            photoService.notifyListeners();
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (photos[key] == null) ...[
              const Icon(Icons.camera_alt, size: 48),
              Text(label),
            ] else
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(photos[key]!, fit: BoxFit.cover),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black54,
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          label,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
