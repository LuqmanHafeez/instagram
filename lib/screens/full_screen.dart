import 'package:flutter/material.dart';

class FullImage extends StatelessWidget {
  final imageUrl;
  const FullImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.network(imageUrl));
  }
}
