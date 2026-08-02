import 'package:flutter/material.dart';
import 'package:reminder_app/models/note_model.dart';
import 'package:reminder_app/views/cubits/notes_cubit/notes_cubit.dart';
import 'package:reminder_app/views/widgets/note_item.dart';
import 'package:reminder_app/views/widgets/upcoming_reminders_list.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key, required this.notes});
  final List<NoteModel> notes;

  @override
  Widget build(BuildContext context) {
    List<NoteModel> pinnedNotes =  NotesCubit.get(context).pinnedNotes;
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        if (pinnedNotes.isNotEmpty) ...[
          const SliverToBoxAdapter(
            child: Text(
              'Pinned',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          // list view horizontal of pinned notes
          SliverToBoxAdapter(
            child: SizedBox(
              height: 150,
              child: PinnedRemindersList(pinnedNotes: pinnedNotes),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
        const SliverToBoxAdapter(
          child: Text(
            'Upcoming',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        // Staggered grid view
        UpcomingRemindersList(notes: notes),
        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }
}

//----------------------------------
class PinnedRemindersList extends StatelessWidget {
  const PinnedRemindersList({super.key, required this.pinnedNotes});

  final List<NoteModel> pinnedNotes;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return ReminderNoteItem(note: pinnedNotes[index]);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(width: 10);
      },
      itemCount: pinnedNotes.length,
    );
  }
}

///////////////////////////
