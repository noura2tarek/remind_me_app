import 'package:flutter/material.dart';
import 'package:reminder_app/modules/add_new_reminder_page.dart';

// No reminders page and add new reminder
class NoRemindersPage extends StatelessWidget {
  const NoRemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Reminders',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add new reminder page
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddNewReminderPage()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Add your title and description of your reminder
          Image.asset('assets/images/no_reminders.png'),
          SizedBox(height: 20),
          // no reminders text
          Text(
            'No reminders',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
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
      ),
    );
  }
}
