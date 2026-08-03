import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder_app/models/note_model.dart';
import 'package:reminder_app/views/cubits/notes_cubit/notes_cubit.dart';
import 'package:reminder_app/views/pages/home/no_reminders_page.dart';
import 'package:reminder_app/views/pages/home/reminders_page.dart';
import 'package:reminder_app/views/widgets/reminders_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // if notes box have empty data show no reminders page or notes page when have data
    return Padding(
      padding: const EdgeInsets.only(top: 66, bottom: 16, right: 16, left: 16),
      child: RefreshIndicator(
        onRefresh: () async => NotesCubit.get(context).fetchNotes(),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RemindersText(),
            SizedBox(height: 25),
            // rest of the page -- notes or empty data
            Expanded(child: RestOfThePage()),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

////////////////////
class RestOfThePage extends StatelessWidget {
  const RestOfThePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        List<NoteModel> notes = BlocProvider.of<NotesCubit>(context).notes;
        List<NoteModel> upcomingNotes = BlocProvider.of<NotesCubit>(context).upcomingNotes;
        return notes.isEmpty
            ? const SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: NoRemindersPage(),
              )
            : RemindersPage(upcomingNotes: upcomingNotes);
      },
    );
  }
}
