import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:reminder_app/models/note_model.dart';
import 'package:reminder_app/utils/constants.dart';

part 'add_note_state.dart';

List<Color> colors = [
  Colors.redAccent,
  Colors.blue,
  Colors.purple,
  Colors.orangeAccent,
  Colors.pink,
  Colors.pinkAccent,
];
class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit() : super(AddNoteInitial());

  Color noteColor = colors.first;

  void changeColor(Color color) {
    noteColor = color;
    emit(NoteChangeColor());
  }

  // Add note to notes bos using hive method
  void addNote(NoteModel note) async {
    // add color to note
    note.color = noteColor.toARGB32();
    emit(AddNoteLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    // access notes box
    try {
      var box = Hive.box<NoteModel>(kNotesBox);
      // add note
      await box.add(note);
      emit(AddNoteSuccess(title: note.title));
    } catch (e) {
      emit(AddNoteError(errorMsg: e.toString()));
    }
  }
}
