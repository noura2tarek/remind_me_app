import 'package:flutter/material.dart';
import 'package:reminder_app/utils/constants.dart';

class TextFormFieldRead extends StatelessWidget {
  const TextFormFieldRead({
    super.key,
    required this.controller,
    required this.hintText,
    required this.suffixIcon,
  });
  final TextEditingController controller;
  final String hintText;
  final Widget suffixIcon;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 49,
      child: TextFormField(
        readOnly: true,
        controller: controller,
        keyboardType: TextInputType.none,
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: kFillColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
//IconButton(
            // show date picker
          //   onPressed: onSuffixPressed,
          //   icon: Icon(suffixIcon),
          // ),
//
//
//
