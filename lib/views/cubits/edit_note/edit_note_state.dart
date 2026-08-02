part of 'edit_note_cubit.dart';

@immutable
abstract class EditNoteState {}

class EditNoteInitial extends EditNoteState {}

class NoteChangeColor extends EditNoteState {}

class NoteChangePinned extends EditNoteState {}

class ReminderDeleted extends EditNoteState {}

class ReminderSent extends EditNoteState {}

class EditNoteSuccess extends EditNoteState {}
class EditNoteError extends EditNoteState {
  final String errorMsg;
  EditNoteError({required this.errorMsg});
}

class NoteChangeRepeatOption extends EditNoteState {}
class NoteChangeReminderDate extends EditNoteState {}
class NoteChangeReminderTime extends EditNoteState {}
class NoteChangeTitle extends EditNoteState {}
class NoteChangeContent extends EditNoteState {}

 




