import 'package:flutter/material.dart';

class DetectUploadScreen extends StatelessWidget {
  const DetectUploadScreen({super.key});

  void openFileChooser() {
    // Logic to open file picker
  }

  void predictImage() {
    // Logic to predict the selected image
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Text(
            "Détection via Upload d'Image",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: const Center(
                child: Text("Image Display Placeholder"),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: openFileChooser,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4D0080)),
                child: const Text("Choisir une Image"),
              ),
              ElevatedButton(
                onPressed: predictImage,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4ECF52)),
                child: const Text("Prédire"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text("Retour"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
