import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder_app/models/note_model.dart';
import 'package:reminder_app/utils/constants.dart';
import 'package:reminder_app/views/cubits/notes_cubit/notes_cubit.dart';
import 'package:reminder_app/views/widgets/reminders_text.dart';
import 'package:reminder_app/views/widgets/search_text_field.dart';
import 'package:reminder_app/views/widgets/upcoming_reminders_list.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // if notes box have empty data show no reminders text or notes page when have data
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 60, bottom: 16, right: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RemindersText(title: 'Search Reminders', fontSize: 22),

            // Search text field
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SearchTextField(),
            ),
            // rest of the page -- notes or empty data
            Expanded(child: RemindersList()),
          ],
        ),
      ),
    );
  }
}

////////////////////
class RemindersList extends StatelessWidget {
  const RemindersList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        List<NoteModel> searchNotes = BlocProvider.of<NotesCubit>(
          context,
        ).notesSearchList;

        return (state is NoteSearchEmptyData || searchNotes.isEmpty)
            ? Center(
                child: Text(
                  state is NoteSearchEmptyData ? 'No reminders found' : '',
                  style: const TextStyle(color: kTextColor, fontSize: 20),
                ),
              )
            : RemindersSearchGridView(
                searchNotes: searchNotes,
              ); // Staggered grid view
      },
    );
  }
}

class RemindersSearchGridView extends StatelessWidget {
  const RemindersSearchGridView({super.key, required this.searchNotes});
  final List<NoteModel> searchNotes;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: searchNotes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final note = searchNotes[index];
        return ReminderNoteItem2(note: note);
      },
    );
  }
}
