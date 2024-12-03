import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import to use SystemNavigator

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcoming text
            const Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Description or subheading
            const Text(
              'Explore the features of the app and navigate to various sections.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Another button example for other pages
            ElevatedButton(
              onPressed: () {
                // Navigate to another screen
                Navigator.pushNamed(context, '/detection');
              },
              child: const Text('Object Detector'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Navigation Button
            ElevatedButton(
              onPressed: () {
                // Navigate to the HistoryScreen (or any other screen)
                Navigator.pushNamed(context, '/history');
              },
              child: const Text('View History'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Quit Button
            ElevatedButton(
              onPressed: () {
                // Quit the app
                SystemNavigator.pop();  // This closes the app
              },
              child: const Text('Quit'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
