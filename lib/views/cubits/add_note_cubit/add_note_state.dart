part of 'add_note_cubit.dart';

@immutable
abstract class AddNoteState {}

class AddNoteInitial extends AddNoteState {}
// one state and copy with constructor
// or single states

class AddNoteLoading extends AddNoteState {}

class AddNoteSuccess extends AddNoteState {
  AddNoteSuccess();
}

class AddNoteError extends AddNoteState {
  final String errorMsg;
  AddNoteError({required this.errorMsg});
}

class NoteChangeColor extends AddNoteState {}

class ReminderChanged extends AddNoteState {}

class ReminderDeleted extends AddNoteState {}

class DateChanged extends AddNoteState {}

class TimeChanged extends AddNoteState {}

class RepeatChanged extends AddNoteState {}

class ReminderSent extends AddNoteState {}

class NoteChangePinned extends AddNoteState {}

class ReminderFails extends AddNoteState {}
