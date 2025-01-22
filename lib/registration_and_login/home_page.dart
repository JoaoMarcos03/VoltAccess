import 'package:flutter/material.dart';
import 'package:voltaccess/info_pages/history.dart'; // importuj history.dart
import 'package:voltaccess/info_pages/user_info.dart'; // importuj user_info.dart
import 'package:voltaccess/marcos/map.dart'; // importuj map.dart
import 'package:voltaccess/registration_and_login/login_view.dart'; // Import LoginView

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VoltAccess',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo na środku
              Image.asset(
                'lib/logo.webp', 
                height: 100,
              ),
              const SizedBox(height: 40),

              // Historia przejazdów
              _buildMenuButton(context, 'History of the Rides', const RideHistoryPage(), Colors.black, Colors.white),
              const SizedBox(height: 15),

              // Profil użytkownika
              _buildMenuButton(context, 'User Profile', const UserProfilePage(), Colors.black, Colors.white),
              const SizedBox(height: 15),

              // Wynajem aut
              _buildMenuButton(context, 'Renting Cars', const RentingCarsPage(), Colors.black, Colors.white),
              const SizedBox(height: 30),

              // Przycisk "Log Out" w stylu "Register"
              _buildMenuButton(context, 'Log Out', const LoginView(title: 'Login'), Colors.grey[300]!, Colors.black, isLogout: true),
            ],
          ),
        ),
      ),
    );
  }

  // Funkcja pomocnicza do budowania przycisków menu
  Widget _buildMenuButton(BuildContext context, String text, Widget page, Color bgColor, Color textColor, {bool isLogout = false}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        if (isLogout) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => page),
            (route) => false,
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }
}
