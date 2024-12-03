import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '/helpers/database_helper.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  _DetectionScreenState createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  XFile? capturedImage;
  bool isFrontCamera = false;
  bool isFlashOn = false;  // Flash state
  String? predictionLabel;
  double? predictionConfidence;
  Interpreter? interpreter;
  List<String>? labels;
  bool isLoading = false;
  // Add an instance of DatabaseHelper
  final DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    initializeCamera();
    loadModel();
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      cameraController = CameraController(
        cameras![isFrontCamera ? 1 : 0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await cameraController!.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/models/model.tflite');
      String labelsData = await DefaultAssetBundle.of(context).loadString('assets/models/labels.txt');
      labels = labelsData.split('\n');
      print("Model and labels loaded successfully.");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  void switchCamera() async {
    try {
      setState(() {
        isFrontCamera = !isFrontCamera;
      });
      await cameraController?.dispose();
      await initializeCamera();
    } catch (e) {
      print('Error switching camera: $e');
    }
  }

  void takePicture() async {
    try {
      if (cameraController != null && cameraController!.value.isInitialized) {
        final image = await cameraController!.takePicture();
        setState(() {
          capturedImage = image;
          isLoading = true;
        });
        classifyImage(File(capturedImage!.path));
      }
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> classifyImage(File image) async {
    try {
      if (interpreter == null || labels == null) {
        print("Model or labels not loaded.");
        return;
      }

      // Preprocess the image
      final inputImage = image.readAsBytesSync();
      final input = preprocessImage(inputImage);

      // Allocate output buffer
      var output = List.filled(1 * labels!.length, 0.0).reshape([1, labels!.length]);

      // Run inference
      interpreter!.run(input, output);

      // Get predictions
      List<double> predictions = output[0];

      int maxIndex = predictions.indexOf(predictions.reduce((a, b) => a > b ? a : b));

      setState(() {
        predictionLabel = labels![maxIndex];
        predictionConfidence = predictions[maxIndex];
        isLoading = false;
      });

    } catch (e) {
      print('Error classifying image: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<List<List<List<double>>>> preprocessImage(Uint8List inputImage) {
    img.Image? image = img.decodeImage(inputImage);
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize image to 224x224 (assuming model input size is 224x224)
    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

    // Convert image to 3D list of integers (height x width x channels)
    List<List<List<int>>> imageData = List.generate(
      resizedImage.height,
      (h) => List.generate(
        resizedImage.width,
        (w) => [
          img.getRed(resizedImage.getPixel(w, h)),
          img.getGreen(resizedImage.getPixel(w, h)),
          img.getBlue(resizedImage.getPixel(w, h))
        ]
      ),
    );

    return [imageData.map((e) => e.map((e) => e.map((e) => e / 255).toList()).toList()).toList()];
  }

  // Toggle Flash
  void toggleFlash() async {
    try {
      setState(() {
        isFlashOn = !isFlashOn;
      });
      if (cameraController != null) {
        await cameraController!.setFlashMode(isFlashOn ? FlashMode.torch : FlashMode.off);
      }
    } catch (e) {
      print('Error toggling flash: $e');
    }
  }

  // Select image from gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        capturedImage = pickedFile;
        isLoading = true;
      });
      classifyImage(File(capturedImage!.path));
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          capturedImage == null
              ? CameraPreview(cameraController!)
              : Column(
                  children: [
                    if (predictionLabel != null && !isLoading)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Prediction: $predictionLabel\t||\tConfidence: ${(predictionConfidence! * 100).toStringAsFixed(2)}%",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Expanded(
                      child: Image.file(
                        File(capturedImage!.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    if (isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: switchCamera,
                    child: const Icon(Icons.switch_camera),
                  ),
                  FloatingActionButton(
                    onPressed: takePicture,
                    child: const Icon(Icons.camera),
                  ),
                  FloatingActionButton(
                    onPressed: toggleFlash,
                    child: Icon(isFlashOn ? Icons.flash_off : Icons.flash_on),
                  ),
                  FloatingActionButton(
                    onPressed: pickImage,
                    child: const Icon(Icons.image),
                  ),
                  if (capturedImage != null)
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          capturedImage = null;
                          predictionLabel = null;
                          predictionConfidence = null;
                        });
                      },
                      child: const Icon(Icons.refresh),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
