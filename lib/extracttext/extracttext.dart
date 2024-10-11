import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<String> extract(String imagePath) async {
  final inputImage = InputImage.fromFilePath(imagePath);
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);

  String text = recognizedText.text;

  return text;
}
