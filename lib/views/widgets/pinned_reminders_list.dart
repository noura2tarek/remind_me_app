import 'package:flutter/material.dart';
import 'package:reminder_app/models/note_model.dart';
import 'package:reminder_app/views/widgets/reminder_note_item.dart';

class PinnedRemindersList extends StatelessWidget {
  const PinnedRemindersList({super.key, required this.pinnedNotes});

  final List<NoteModel> pinnedNotes;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return ReminderNoteItemPinned(note: pinnedNotes[index]);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(width: 8);
      },
      itemCount: pinnedNotes.length,
    );
  }
}
