import 'package:flutter/material.dart';
import '/helpers/database_helper.dart';
import 'dart:typed_data'; // For Uint8List to handle image data

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Store the list of images
  late Future<List<Map<String, dynamic>>> _images;

  @override
  void initState() {
    super.initState();
    // Initialize the images
    _images = fetchImages();
  }

  // Fetch image data from the database
  Future<List<Map<String, dynamic>>> fetchImages() async {
    final dbHelper = DatabaseHelper.instance;
    final List<Map<String, dynamic>> images = await dbHelper.fetchAllImages();
    return images;
  }

  // Delete image method
  void deleteImage(BuildContext context, int id) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.deleteImageById(id); // Call the delete method from DatabaseHelper

    // Show a snackbar message after deletion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image deleted')),
    );

    // Re-fetch the images to update the UI
    setState(() {
      _images = fetchImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _images, // Use the stateful image list
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No images found'));
                } else {
                  final images = snapshot.data!;
                  return ListView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final image = images[index];
                      final imageId = image['_id'] as int; // Get the image ID
                      final imageData = image['image'] as Uint8List; // Use as Uint8List
                      final label = image['label'];
                      final confidence = image['confidence'];
                      final date = image['date'];
                      final time = image['time'];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display the image
                              Image.memory(imageData),
                              const SizedBox(height: 10),
                              
                              // Label and delete icon aligned in a Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Label: $label",
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteImage(context, imageId), // Delete image
                                  ),
                                ],
                              ),
                              
                              Text(
                                "Confidence: ${(confidence * 100).toStringAsFixed(2)}%",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 5),
                              // Display the date and time
                              Text(
                                "Date: $date, Time: $time",
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
