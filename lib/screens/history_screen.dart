import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Text(
            "Historique des détections",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with dynamic data
              itemBuilder: (context, index) {
                return ListTile(
                  title: const Text("Image Placeholder"),
                  subtitle: Text("Classe Prédite - ${DateTime.now()}"),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            child: const Text("Retour"),
          ),
        ],
      ),
    );
  }
}
