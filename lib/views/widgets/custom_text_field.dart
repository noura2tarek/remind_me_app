import 'package:flutter/material.dart';
import 'package:remind_me/utils/constants.dart';

// custom text field of notes
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.noteColor,
    required this.hintText,
    this.fontSize = 18,
    this.maxlines = 1,
    this.onChanged,
  });
  final TextEditingController controller;
  final Color noteColor;
  final String hintText;
  final double fontSize;
  final int maxlines;
  final void Function(String)? onChanged;
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
      onChanged: onChanged,
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
