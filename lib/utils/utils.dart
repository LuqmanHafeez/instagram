import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/utils/dimension.dart';

const dumyProfileUrl =
    "https://img.freepik.com/free-icon/woman_318-157570.jpg?w=2000";

Future pickImage(ImageSource source) async {
  ImagePicker _imagePicker = ImagePicker();
  Uint8List image;
  XFile? xfile = await _imagePicker.pickImage(
      source: source, imageQuality: kIsWeb ? 25 : null);
  if (xfile != null) {
    //return await xfile.readAsBytes();
    image = await xfile.readAsBytes();
    return image;
  }
  return "No image Selected";
}

showSnackBar(
  BuildContext context,
  String content,
) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
    content,
    style: const TextStyle(color: kIsWeb ? Colors.black : Colors.white),
  )));
}
