import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'services/tflite_service.dart';
import 'treatments/disease_info.dart';

void main() {
  runApp(const PlantDoctorApp());
}

class PlantDoctorApp extends StatelessWidget {
  const PlantDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Plant Doctor AI",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TFLiteService tflite = TFLiteService();

  File? image;

  String prediction = "";
  String confidence = "";

  Map<String, dynamic>? disease;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    await tflite.loadModel();
    debugPrint("Model Loaded Successfully");
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked == null) return;

    final file = File(picked.path);

    final result = await tflite.predict(file);

    setState(() {
      image = file;
      prediction = result["label"].toString().trim();
      confidence = result["confidence"].toString();

      debugPrint("Prediction = '$prediction'");
      debugPrint("All Keys:");
      debugPrint(diseaseInfo.keys.toString());

      disease = diseaseInfo[prediction];

      debugPrint("Disease Found: ${disease != null}");
    });
  }

  @override
  void dispose() {
    tflite.interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🌿 Plant Doctor AI"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            image == null
                ? Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.image,
                      size: 120,
                      color: Colors.grey,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      image!,
                      height: 280,
                      fit: BoxFit.cover,
                    ),
                  ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.photo),
                label: const Text(
                  "Choose Leaf Image",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 30),

            if (prediction.isNotEmpty)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "🌱 Plant",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        disease?["plant"] ?? prediction,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Divider(height: 30),

                      const Text(
                        "Disease",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        disease?["disease"] ?? prediction,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Confidence : $confidence %",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 25),

                      if (disease != null) ...[
                        const Text(
                          "Symptoms",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          disease!["symptoms"],
                          style: const TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          "Treatment",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          disease!["treatment"],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}