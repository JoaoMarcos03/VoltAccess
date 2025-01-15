import 'package:flutter/material.dart';
import 'package:voltaccess/info_pages/history.dart'; // importuj history.dart
import 'package:voltaccess/info_pages/user_info.dart'; // importuj user_info.dart
import 'package:voltaccess/marcos/map.dart'; // importuj map.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Otwórz stronę historii przejazdów
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RideHistoryPage()),
                );
              },
              child: const Text('History of the Rides'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Otwórz stronę profilu użytkownika
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfilePage()),
                );
              },
              child: const Text('User Profile'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Otwórz stronę wynajmu samochodów
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RentingCarsPage()),
                );
              },
              child: const Text('Renting Cars'),
            ),
          ],
        ),
      ),
    );
  }
}
