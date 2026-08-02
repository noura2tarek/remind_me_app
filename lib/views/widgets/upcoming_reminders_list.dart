import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:reminder_app/models/note_model.dart';
import 'package:reminder_app/services/navigation_service.dart';
import 'package:reminder_app/utils/functions.dart';
import 'package:reminder_app/views/cubits/edit_note/edit_note_cubit.dart';
import 'package:reminder_app/views/cubits/notes_cubit/notes_cubit.dart';
import 'package:reminder_app/views/pages/edit_reminder_page.dart';

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
        return ReminderNoteItem2(note: note);
      },
    );
  }
}

//-----------------------
class ReminderNoteItem2 extends StatelessWidget {
  const ReminderNoteItem2({super.key, required this.note});

  final NoteModel note;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //show dialog on log press and delete model
      onLongPress: () async {
        return await showDialog(
          context: context,
          builder: (context2) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Confirm you want to delete the note or not'),
              actions: [
                // cancel
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context2, false);
                  },
                  child: const Text('Cancel'),
                ),
                // delete
                OutlinedButton(
                  onPressed: () async {
                    // delete note function
                    deleteNote(note, context);
                    Navigator.pop(context2, true);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      onTap: () {
        NavigationService.navigateTo(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => EditNoteCubit()),
              BlocProvider.value(value: NotesCubit.get(context)),
            ],
            child: EditReminderPage(note: note),
          ),
          context,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(note.color ?? 0xff000000),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              note.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            if (note.content != null && note.content!.isNotEmpty)
              Text(
                note.content ?? "",
                style: const TextStyle(color: Colors.black54),
              ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(note.colorBorderDate ?? 0xffffffff),
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(formatReminder(note.date)),
            ),
          ],
        ),
      ),
    );
  }

  // delete note function
  Future<void> deleteNote(NoteModel note, BuildContext context) async {
    NotesCubit.get(context).deleteNote(note);
  }
}
