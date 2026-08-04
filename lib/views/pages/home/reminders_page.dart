import 'package:flutter/material.dart';
import 'package:reminder_app/models/note_model.dart';
import 'package:reminder_app/views/cubits/notes_cubit/notes_cubit.dart';
import 'package:reminder_app/views/widgets/reminder_note_item.dart';
import 'package:reminder_app/views/widgets/pinned_reminders_list.dart';
import 'package:reminder_app/views/widgets/upcoming_reminders_list.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key, required this.upcomingNotes});
  final List<NoteModel> upcomingNotes;

  @override
  Widget build(BuildContext context) {
    List<NoteModel> pinnedNotes = NotesCubit.get(context).pinnedNotes;
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
              height: 129,
              child: PinnedRemindersList(pinnedNotes: pinnedNotes),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
        if (upcomingNotes.isNotEmpty) ...[
          const SliverToBoxAdapter(
            child: Text(
              'Upcoming',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          // Staggered grid view
          UpcomingRemindersList(notes: upcomingNotes),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }
}

//----------------------------------

///////////////////////////
