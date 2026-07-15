# Plant Doctor AI

## Overview

Plant Doctor AI is an offline Android application developed using Flutter and TensorFlow Lite for plant disease detection. The application allows users to select a leaf image from their gallery, identifies the plant disease using a deep learning model, and displays confidence, symptoms, treatment, and prevention information.

The machine learning model was trained in Google Colab using the PlantVillage dataset and converted to TensorFlow Lite for on-device inference.

---

## Features

- Offline plant disease detection
- TensorFlow Lite model integration
- Gallery image selection
- Prediction confidence score
- Plant and disease identification
- Disease symptoms
- Treatment recommendations
- Prevention tips
- Supports 38 plant disease classes

---

## Tech Stack

### Mobile Application
- Flutter
- Dart
- TensorFlow Lite
- Image Picker

### Machine Learning
- Python
- TensorFlow / Keras
- Google Colab
- EfficientNetB0
- NumPy
- OpenCV
- Matplotlib

---

## Project Structure

```
plant_doctor_ai/
│
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
│
├── assets/
│   └── models/
│       ├── plant_doctor_model.tflite
│       └── labels.txt
│
├── lib/
│   ├── services/
│   │   └── tflite_service.dart
│   │
│   ├── treatments/
│   │   └── disease_info.dart
│   │
│   └── main.dart
│
├── PlantDiseaseTraining.ipynb
├── pubspec.yaml
├── README.md
└── .gitignore
```

---

## Supported Plants

- Apple
- Blueberry
- Cherry
- Corn (Maize)
- Grape
- Orange
- Peach
- Bell Pepper
- Potato
- Raspberry
- Soybean
- Squash
- Strawberry
- Tomato

---

## Model Details

- Model Architecture: EfficientNetB0
- Framework: TensorFlow / Keras
- Deployment: TensorFlow Lite
- Input Size: 224 × 224 × 3
- Number of Classes: 38
- Runs entirely on-device without requiring an internet connection.

---

## Dataset

This project uses the PlantVillage dataset for training and evaluation.

The dataset is not included in this repository due to its large size.

---

## Running the Application

Clone the repository:

```bash
git clone https://github.com/mur-leeee/Plant-Doctor-AI.git
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

## Building the APK

```bash
flutter build apk --release
```

The generated APK can be found at:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Training

The complete model training, evaluation, and TensorFlow Lite conversion process is available in:

```
PlantDiseaseTraining.ipynb
```

---

## Future Improvements

- Camera support
- Improved UI/UX
- Better disease descriptions
- Additional crop support
- Disease severity estimation
- Multi-language support
- Cloud synchronization
