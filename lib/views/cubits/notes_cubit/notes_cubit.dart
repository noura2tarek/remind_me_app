import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:reminder_app/models/note_model.dart';
import 'package:reminder_app/services/notifications_service.dart';
import 'package:reminder_app/utils/constants.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NoteInitial());

  // notes cubit object
  static NotesCubit get(BuildContext context) =>
      BlocProvider.of<NotesCubit>(context);
  List<NoteModel> notes = [];
  // fetch notes from hive
  void fetchNotes() {
    var box = Hive.box<NoteModel>(kRemindersBox);
    notes = box.values.toList();
    // get reminders
    NotificationsService().getPendingNotifications();
    emit(NotesSuccess());
  }
}
