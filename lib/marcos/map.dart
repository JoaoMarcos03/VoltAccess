import 'package:flutter/material.dart';

class RentingCarsPage extends StatelessWidget {
  const RentingCarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renting Cars'),
      ),
      body: const Center(
        child: Text(
          'Browse and rent cars here!',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}