import 'package:flutter/material.dart';
import 'package:reminder_app/utils/app_assets.dart';
import 'package:reminder_app/utils/constants.dart';

// No reminders page and add new reminder
class NoRemindersPage extends StatelessWidget {
  const NoRemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    //backgroundColor: Colors.white,
    // floatingActionButton: FloatingActionButton(
    //   onPressed: () {
    //     // Navigate to add new reminder page
    //     Navigator.of(context).push(
    //       MaterialPageRoute(builder: (context) => const AddNewReminderPage()),
    //     );
    //   },
    //   backgroundColor: Theme.of(context).colorScheme.primary,
    //   child: const Icon(Icons.add, color: Colors.white),
    // ),
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add your title and description of your reminder
        Image.asset(Assets.imageOfNoReminders),
        SizedBox(height: 15),
        // no reminders text
        Center(
          child: Text(
            'No reminders',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: subTitleColor,
            ),
          ),
        ),
        // body
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'You have no reminders yet. Tap the button below to add a new reminder.',
            style: TextStyle(fontSize: 16, color: Colors.black45),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
