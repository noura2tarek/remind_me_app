part of 'add_note_cubit.dart';

@immutable
abstract class AddNoteState {}

class AddNoteInitial extends AddNoteState {}
// one state and copy with constructor 
// or single states

class AddNoteLoading extends AddNoteState{}
class AddNoteSuccess extends AddNoteState{
  final String? title;
  AddNoteSuccess({required this.title});
}
class AddNoteError extends AddNoteState{
  final String errorMsg;
  AddNoteError({required this.errorMsg});
}

class NoteChangeColor extends AddNoteState{}

class ReminderChanged extends AddNoteState{}
class ReminderDeleted extends AddNoteState{}

class DateChanged extends AddNoteState{}

class TimeChanged extends AddNoteState{}
