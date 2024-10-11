import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

Future<String> CropperImage(BuildContext context, String path) async {
  String cropperPath = '';
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: path,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: 'Select the texte Zone',
      ),
      WebUiSettings(
        context: context,
      ),
    ],
  );

  if (croppedFile != null) {
    cropperPath = croppedFile.path;
  }
  return cropperPath;
}
