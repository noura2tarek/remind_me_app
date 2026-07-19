import 'package:flutter/material.dart';
import 'package:reminder_app/utils/constants.dart';

// custom text field of notes
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.noteColor,
    required this.hintText,
    this.fontSize = 18,
    this.maxlines = 1,
  });
  final TextEditingController controller;
  final Color noteColor;
  final String hintText;
  final double fontSize;
  final int maxlines;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.text,
      maxLines: maxlines,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      style: TextStyle(
        fontSize: fontSize,
        color: noteColor == Colors.black38 ? Colors.white : kTextColor,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: fontSize,
          color: noteColor == Colors.black38 ? Colors.white : kTextColor,
        ),
        border: InputBorder.none,
        // labelStyle: TextStyle(
        //   fontSize: fontSize,
        //   color: noteColor == Colors.black38 ? Colors.white : kTextColor,
        // ),
      ),
    );
  }
}
