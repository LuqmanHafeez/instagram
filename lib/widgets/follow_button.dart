import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';

class FollowButton extends StatefulWidget {
  final function;
  final text;
  final color;
  final backGroundColor;
  final textColor;
  const FollowButton(
      {super.key,
      this.function,
      required this.text,
      required this.color,
      required this.backGroundColor,
      required this.textColor});

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.function,
      child: Container(
        width: 200.0,
        height: 27.0,
        //color: widget.backGroundColor,
        decoration: BoxDecoration(
            color: widget.backGroundColor,
            border: Border.all(color: widget.color),
            borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        child: Text(
          widget.text,
          style: TextStyle(color: widget.textColor),
        ),
      ),
    );
  }
}
