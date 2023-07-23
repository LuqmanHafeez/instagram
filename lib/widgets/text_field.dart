import 'package:flutter/material.dart';

class TextFieldClass extends StatelessWidget {
  final bool obsecureText;
  final TextInputType? textInputType;
  final TextEditingController textEditingController;
  final String hintText;
  final String? Function(String?)? validator;
  const TextFieldClass({
    this.obsecureText = false,
    this.textInputType,
    required this.textEditingController,
    required this.hintText,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));

    // return Container(height: 200, width: 500);
    return TextFormField(
      validator: validator,
      obscureText: obsecureText,
      keyboardType: textInputType,
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hintText,
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder),
    );
  }
}
