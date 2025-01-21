import 'package:flutter/material.dart';

class AddCardPage extends StatelessWidget {
  const AddCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Payment Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your payment card details:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Pole na numer karty
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                hintText: 'Enter card number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Pole na imię właściciela karty
            TextField(
              decoration: const InputDecoration(
                labelText: 'Cardholder Name',
                hintText: 'Enter cardholder name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Pole na datę ważności karty
            TextField(
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                labelText: 'Expiration Date',
                hintText: 'MM/YY',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Pole na CVV
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'CVV',
                hintText: 'Enter CVV',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Obsługuje akcję po dodaniu karty (np. zapisanie danych)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment card added successfully!')),
                );
              },
              child: const Text('Submit Card'),
            ),
          ],
        ),
      ),
    );
  }
}
