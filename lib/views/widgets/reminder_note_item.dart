import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:remind_me/models/note_model.dart';
import 'package:remind_me/services/navigation_service.dart';
import 'package:remind_me/utils/constants.dart';
import 'package:remind_me/views/cubits/edit_note/edit_note_cubit.dart';
import 'package:remind_me/views/cubits/notes_cubit/notes_cubit.dart';
import 'package:remind_me/views/pages/edit_reminder_page.dart';
import 'package:remind_me/views/widgets/note_item.dart';

// Reminder note item pinned
class ReminderNoteItem extends StatelessWidget {
  const ReminderNoteItem({
    super.key,
    required this.note,
    this.inGrid = false,
    this.fromSearch = false,
  });
  final NoteModel note;
  final bool inGrid;
  final bool fromSearch;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(note.id),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              NotesCubit.get(context).changePinStatus(note);
            },
            backgroundColor: kPrimaryColor.withValues(alpha: 0.8),
            foregroundColor: Colors.white,
            icon: Icons.push_pin_outlined,
            label: (note.isPinned ?? false) ? 'Unpin' : 'Pin',
          ),
        ],
      ),
      child: NoteItem(
        note: note,
        inGrid: inGrid,
        fromSearch: fromSearch,
        onLongPress: () => longPressDialog(context, note),
        onTap: () => goTotheEditScreen(context, note),
      ),
    );
  }
}

// Reminder Note Item
class ReminderNoteItemPinned extends StatelessWidget {
  const ReminderNoteItemPinned({
    super.key,
    required this.note,
    this.inGrid = false,
    this.fromSearch = false,
  });
  final NoteModel note;
  final bool inGrid;
  final bool fromSearch;
  @override
  Widget build(BuildContext context) {
    return NoteItem(
      note: note,
      inGrid: inGrid,
      fromSearch: fromSearch,
      onLongPress: () => longPressDialog(context, note),
      onTap: () => goTotheEditScreen(context, note),
    );
  }
}

// show dialog
Future<bool?> showDialogF(BuildContext context, NoteModel note) async {
  return await showDialog(
    context: context,
    builder: (context2) {
      return BlocProvider.value(
        value: NotesCubit.get(context),
        child: AlertDialog(
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
                Navigator.pop(context2, true);
                deleteNote(note, context);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    },
  );
}

// show dialog on log press to edit or delete
Future<void> longPressDialog(BuildContext context, NoteModel note) {
  return showDialog(
    context: context,
    builder: (context2) {
      return BlocProvider.value(
        value: NotesCubit.get(context),
        child: AlertDialog(
          title: const Text('What do you want to do?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context2, true);
                  goTotheEditScreen(context, note);
                },
                child: const Text('Edit'),
              ),
              // Delete
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  // delete note function
                  Navigator.pop(context2, true);
                  showDialogF(context, note);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// delete note function
Future<void> deleteNote(NoteModel note, BuildContext context) async {
  NotesCubit.get(context).deleteNote(note);
}

// navigate to the edit screen
void goTotheEditScreen(BuildContext context, NoteModel note) {
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
}
