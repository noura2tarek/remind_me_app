import 'package:flutter/material.dart';
import 'package:reminder_app/utils/constants.dart';

class TextFormFieldRead extends StatelessWidget {
  const TextFormFieldRead({
    super.key,
    required this.controller,
    required this.hintText,
    required this.suffixIcon,
    this.onChanged,
  });
  final TextEditingController controller;
  final String hintText;
  final Widget suffixIcon;
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 49,
      child: TextFormField(
        readOnly: true,//-----------
        controller: controller,
        keyboardType: TextInputType.none,//------
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        onChanged: onChanged,
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

