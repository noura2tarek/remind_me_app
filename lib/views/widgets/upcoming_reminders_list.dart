import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:remind_me/models/note_model.dart';
import 'package:remind_me/views/widgets/reminder_note_item.dart';

class UpcomingRemindersList extends StatelessWidget {
  const UpcomingRemindersList({super.key, required this.notes});
  final List<NoteModel> notes;
  @override
  Widget build(BuildContext context) {
    return SliverMasonryGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ReminderNoteItem(note: note, inGrid: true);
      },
    );
  }
}
