import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:remind_me/models/note_model.dart';
import 'package:remind_me/services/notifications_service.dart';
import 'package:remind_me/utils/constants.dart';
import 'package:remind_me/utils/print_state.dart';
part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NoteInitial());

  // notes cubit object
  static NotesCubit get(BuildContext context) =>
      BlocProvider.of<NotesCubit>(context);
  // notes list
  List<NoteModel> notes = [];
  List<NoteModel> pinnedNotes = [];
  List<NoteModel> upcomingNotes = [];

  // fetch notes from hive
  Future<void> fetchNotes() async {
    // get upcoming reminders first
    printLog('Pending remindeers..------------.');
    // final pendingReminders = await NotificationsService()
    //     .getPendingNotifications();
    // final pendingIds = pendingReminders.map((e) => e.id).toSet();

    // for (final item in pendingReminders) {
    //   printLog('pending  reminder ID: ${item.id}, Title: ${item.title}');
    // }
    // printLog('End of Pending reminders..-----------.');

    var box = Hive.box<NoteModel>(kRemindersBox);

    // Get all notes (reminders with colors and other parameters)
    notes = box.values.toList();
    // printLog('All Notes...-------------------------');
    // for (final item in notes) {
    //   printLog(
    //     ' original note ID: ${item.id}, Title: ${item.title} pinned ${item.isPinned}',
    //   );
    // }

    pinnedNotes = notes.where((note) => note.isPinned == true).toList();
    upcomingNotes = notes.where((note) => note.isPinned == false).toList();
    // sort upcoming notes
    upcomingNotes.sort((a, b) => a.date.compareTo(b.date));
    emit(NotesSuccess());
  }

  // search controller
  TextEditingController searchController = TextEditingController();
  //  notes search list
  List<NoteModel> notesSearchList = <NoteModel>[];

  void searchNotes(String query) {
    notesSearchList = notes
        .where((note) => note.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    List<NoteModel> result = [];

    if (notesSearchList.isNotEmpty) {
      result = notesSearchList;
      emit(NoteSearchSuccess(notesSearchList: result));
    } else {
      // result = notes;
      notesSearchList = [];
      emit(NoteSearchEmptyData());
    }
  }

  // On Delete search text
  void onDeleteSearchText() async {
    searchController.clear();
    notesSearchList = [];
    emit(NoteDeleteSearch());
  }

  // Delete note and its reminder
  void deleteNote(NoteModel note) async {
    // delete note's reminder first
    await NotificationsService().cancelNotification(note.id);
    await note.delete();
    emit(NoteDeleted());
    // fetch notes again
    fetchNotes();
  }

  // change pin status

  void changePinStatus(NoteModel note) async {
    bool isPinned = note.isPinned ?? false;
    isPinned = !isPinned;
    note.isPinned = isPinned;
    await note.save();
    fetchNotes();
    emit(NoteChangePinned());
  }
}
