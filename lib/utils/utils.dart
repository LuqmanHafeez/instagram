import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future pickImage(ImageSource source) async {
  ImagePicker _imagePicker = ImagePicker();
  XFile? xfile = await _imagePicker.pickImage(source: source);
  if (xfile != null) {
    return await xfile.readAsBytes();
    //return xfile.path;
  }
  return "No image Selected";
}

showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
