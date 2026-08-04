import 'package:flutter/material.dart';
import 'package:remind_me/utils/constants.dart';

class RemindersText extends StatelessWidget {
  const RemindersText({super.key, this.title = 'Reminders', this.fontSize = 25});
  final String title;
  final double fontSize ;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style:  TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: kTextColor,
      ),
    );
  }
}
