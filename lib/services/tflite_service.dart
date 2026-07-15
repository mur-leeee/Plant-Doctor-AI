import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_litert/flutter_litert.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  Interpreter? interpreter;
  List<String> labels = [];

  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset(
      'assets/models/plant_doctor_model.tflite',
    );

    final labelData =
        await rootBundle.loadString('assets/models/labels.txt');

    labels = labelData
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<Map<String, dynamic>> predict(File imageFile) async {
    final image = img.decodeImage(imageFile.readAsBytesSync())!;

    final resized = img.copyResize(
      image,
      width: 224,
      height: 224,
    );

    final input = List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) {
            final pixel = resized.getPixel(x, y);

            return <double>[
              pixel.r.toDouble(),
              pixel.g.toDouble(),
              pixel.b.toDouble(),
            ];
          },
        ),
      ),
    );

    final output = List.generate(
      1,
      (_) => List.filled(labels.length, 0.0),
    );

    interpreter!.run(input, output);

    int bestIndex = 0;
    double bestScore = output[0][0];

    for (int i = 1; i < output[0].length; i++) {
      if (output[0][i] > bestScore) {
        bestScore = output[0][i];
        bestIndex = i;
      }
    }

    return {
      "label": labels[bestIndex].trim(),
      "confidence": (bestScore * 100).toStringAsFixed(2),
    };
  }

  void dispose() {
    interpreter?.close();
  }
}