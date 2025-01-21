import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voltaccess/registration_and_login/add_card.dart';

class LicenseUploadPage extends StatefulWidget {
  const LicenseUploadPage({Key? key}) : super(key: key);

  @override
  _LicenseUploadPageState createState() => _LicenseUploadPageState();
}

class _LicenseUploadPageState extends State<LicenseUploadPage> {
  File? _licenseImage;

  Future<void> _pickLicenseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _licenseImage = File(pickedFile.path);  // Zapisz ścieżkę obrazu
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload License Image'),
      ),
      body: SingleChildScrollView( // Dodajemy scrollowanie, aby unikać overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickLicenseImage,
                child: const Text('Take a Picture of Your License'),
              ),
              const SizedBox(height: 20),
              _licenseImage != null
                  ? Image.file(_licenseImage!)  // Wyświetl obrazek jeśli istnieje
                  : const Text('No image selected.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Po zarejestrowaniu użytkownika przekierowujemy do strony dodawania karty
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddCardPage()),
                  );
                },
                child: const Text('Submit'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
