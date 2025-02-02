import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class PhotoService extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  Map<String, File?> preRidePhotos = {
    'front': null,
    'back': null,
    'left': null,
    'right': null,
  };
  
  Map<String, File?> postRidePhotos = {
    'front': null,
    'back': null,
    'left': null,
    'right': null,
  };

  Future<File?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50, // Lower quality for better performance
        preferredCameraDevice: CameraDevice.rear,
        maxWidth: 1000, // Limit image size
        maxHeight: 1000,
      );
      
      if (photo == null) return null;
      
      // Create optimized file
      final File file = File(photo.path);
      return file;
    } catch (e) {
      debugPrint('Error taking photo: $e');
      return null;
    }
  }

  bool arePreRidePhotosComplete() {
    return !preRidePhotos.values.contains(null);
  }

  bool arePostRidePhotosComplete() {
    return !postRidePhotos.values.contains(null);
  }

  void clearPhotos() {
    preRidePhotos = Map.fromIterables(
      preRidePhotos.keys,
      List.filled(preRidePhotos.length, null),
    );
    postRidePhotos = Map.fromIterables(
      postRidePhotos.keys,
      List.filled(postRidePhotos.length, null),
    );
    notifyListeners();
  }

  Map<String, File> getPreRidePhotos() {
    return Map.fromEntries(
      preRidePhotos.entries.where((e) => e.value != null)
          .map((e) => MapEntry(e.key, e.value!))
    );
  }

  Map<String, File> getPostRidePhotos() {
    return Map.fromEntries(
      postRidePhotos.entries.where((e) => e.value != null)
          .map((e) => MapEntry(e.key, e.value!))
    );
  }
}
