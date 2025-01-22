import 'package:flutter/material.dart';
import 'package:voltaccess/registration_and_login/login_view.dart';

class AddCardPage extends StatelessWidget {
  const AddCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Całkowicie biały ekran
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo na środku
              Center(
                child: Image.asset(
                  'lib/logo.webp',
                  height: 80, // Dopasowanie do obrazka
                ),
              ),
              const SizedBox(height: 40),

              // Pole na numer karty
              _buildTextField('Card Number'),
              const SizedBox(height: 15),

              // Pole na imię właściciela karty
              _buildTextField("Cardholder Name"),
              const SizedBox(height: 15),

              // Pole na datę ważności karty
              _buildTextField("Expiration Date"),
              const SizedBox(height: 15),

              // Pole na CVV
              _buildTextField("CVV"),
              const SizedBox(height: 30),

              // Czarny przycisk "Submit Card"
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey[850], // Ciemnoszare tło
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.black, width: 2), // Czarna ramka
                        ),
                        title: const Text(
                          'Submission Complete',
                          style: TextStyle(color: Colors.white), // Biały tekst
                        ),
                        content: const Text(
                          'You have to wait for approval. You will receive a confirmation link via email.',
                          style: TextStyle(color: Colors.white), // Biały tekst
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => const LoginView(title: 'Login')),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(color: Colors.white), // Biały tekst
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'Submit Card',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      cursorColor: Colors.black, // Czarny kursor
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200], // Jasnoszare tło pola tekstowego
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2), // Czarna ramka
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2), // Czarna ramka gdy nie kliknięte
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2), // Czarna ramka gdy kliknięte
        ),
      ),
      style: const TextStyle(color: Colors.black), // Czarny tekst w polu
    );
  }
}
