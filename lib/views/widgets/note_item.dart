import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder_app/models/note_model.dart';
import 'package:reminder_app/services/navigation_service.dart';
import 'package:reminder_app/utils/functions.dart';
import 'package:reminder_app/views/cubits/edit_note/edit_note_cubit.dart';
import 'package:reminder_app/views/cubits/notes_cubit/notes_cubit.dart';
import 'package:reminder_app/views/pages/edit_reminder_page.dart';

class ReminderNoteItem extends StatelessWidget {
  const ReminderNoteItem({super.key, required this.note, this.inGrid = false});
  final NoteModel note;
  final bool inGrid;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //show dialog on log press and delete model
      onLongPress: () async {
        return await showDialog(
          context: context,
          builder: (context2) {
            return BlocProvider.value(
              value: NotesCubit.get(context),
              child: AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text(
                  'Confirm you want to delete the note or not',
                ),
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
              ),
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
        constraints: !inGrid ? const BoxConstraints(minHeight: 123) : null,
        padding: const EdgeInsets.all(15),
        width: !inGrid ? MediaQuery.of(context).size.width * 0.45 : null,
        decoration: BoxDecoration(
          color: Color(note.color ?? 0xff000000),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              note.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            if (note.content != null && note.content!.isNotEmpty) ...[
              Text(
                note.content ?? "",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  height: !inGrid ? 1.3 : null,
                ),
              ),
              const SizedBox(height: 10),
            ],
            // Date
            Container(
              padding: !inGrid
                  ? const EdgeInsets.symmetric(horizontal: 8, vertical: 2)
                  : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(note.colorBorderDate ?? 0xffffffff),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Text(
                formatReminder(note.date),
                style: const TextStyle(color: Colors.black54, fontSize: 15),
              ),
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
