import 'package:flutter/material.dart';
import 'package:reminder_app/models/note_model.dart';

class EditReminderPage extends StatefulWidget {
  const EditReminderPage({super.key, this.note});
   final NoteModel? note;
  @override
  State<EditReminderPage> createState() => _EditReminderPageState();
}

class _EditReminderPageState extends State<EditReminderPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}