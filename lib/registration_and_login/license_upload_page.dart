import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voltaccess/registration_and_login/add_card.dart'; // Import AddCardPage

class LicenseUploadPage extends StatefulWidget {
  const LicenseUploadPage({super.key});

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
        _licenseImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Białe tło
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo na środku (jak w AddCardPage)
              Center(
                child: Image.asset(
                  'lib/logo.webp',
                  height: 80, 
                ),
              ),
              const SizedBox(height: 40),

              // Placeholder na zdjęcie prawa jazdy (w stylu pól tekstowych)
              GestureDetector(
                onTap: _pickLicenseImage,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Jasnoszare tło, jak pola tekstowe
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black, width: 2), // Czarna ramka
                  ),
                  child: Center(
                    child: Text(
                      _licenseImage == null ? "Upload License Image" : "Image Selected",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Czarny przycisk "Submit"
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_licenseImage != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddCardPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "Please upload an image first",
                          style: TextStyle(color: Colors.white), // Biały tekst
                        ),
                        backgroundColor: Colors.grey[850], // Ciemnoszare tło
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
