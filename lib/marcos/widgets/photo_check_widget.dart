import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/photo_service.dart';

class PhotoCheckWidget extends StatefulWidget {
  final bool isPreRide;
  final Function onComplete;

  const PhotoCheckWidget({
    super.key,
    required this.isPreRide,
    required this.onComplete,
  });

  @override
  _PhotoCheckWidgetState createState() => _PhotoCheckWidgetState();
}

class _PhotoCheckWidgetState extends State<PhotoCheckWidget> {
  bool _processingPhoto = false;

  Future<void> _handlePhotoCapture(String key, PhotoService photoService) async {
    if (_processingPhoto) return; // Prevent multiple simultaneous captures

    setState(() => _processingPhoto = true);

    try {
      final photo = await photoService.takePhoto();
      if (photo != null) {
        if (widget.isPreRide) {
          photoService.preRidePhotos[key] = photo;
        } else {
          photoService.postRidePhotos[key] = photo;
        }
        photoService.notifyListeners();
      }
    } finally {
      setState(() => _processingPhoto = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoService = Provider.of<PhotoService>(context);
    final photos = widget.isPreRide ? photoService.preRidePhotos : photoService.postRidePhotos;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPreRide ? 'Pre-Ride Check' : 'Post-Ride Check'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              children: [
                _buildPhotoItem('Front', 'front', photos, photoService),
                _buildPhotoItem('Back', 'back', photos, photoService),
                _buildPhotoItem('Left Side', 'left', photos, photoService),
                _buildPhotoItem('Right Side', 'right', photos, photoService),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: (widget.isPreRide ? photoService.arePreRidePhotosComplete()
                  : photoService.arePostRidePhotosComplete())
                  ? () => widget.onComplete()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: (widget.isPreRide ? photoService.arePreRidePhotosComplete()
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
                widget.isPreRide ? 'Start Ride' : 'Complete Ride',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoItem(String label, String key, Map<String, File?> photos, PhotoService photoService) {
    return Card(
      child: Stack(
        children: [
          InkWell(
            onTap: _processingPhoto 
                ? null 
                : () => _handlePhotoCapture(key, photoService),
            child: AspectRatio(
              aspectRatio: 1,
              child: photos[key] == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 48,
                          color: _processingPhoto ? Colors.grey : Colors.black,
                        ),
                        Text(
                          label,
                          style: TextStyle(
                            color: _processingPhoto ? Colors.grey : Colors.black,
                          ),
                        ),
                      ],
                    )
                  : Image.file(
                      photos[key]!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          if (_processingPhoto)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (photos[key] != null)
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
    );
  }
}
