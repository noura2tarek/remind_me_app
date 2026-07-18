import 'package:flutter/material.dart';
import 'package:reminder_app/utils/constants.dart';
import 'package:reminder_app/views/pages/reminders_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override

  Widget build(BuildContext context) {
    // if notes box have empty data show no reminders page or notes page when have data 
    return Padding(
        padding: const EdgeInsets.only(
          top: 40,
          bottom: 16,
          right: 16,
          left: 16,
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
             Text(
              'Reminders',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: kTextColor,
              ),
            ),
            SizedBox(height: 35),
            // rest of the page -- notes or empty data 
            Expanded(child: RemindersPage())
        ],
      ),
    );
  }
}