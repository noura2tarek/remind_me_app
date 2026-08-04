part of 'notes_cubit.dart';

@immutable
abstract class NotesState {}

class NoteInitial extends NotesState {}

class NotesSuccess extends NotesState {}

class NoteDeleted extends NotesState {}

class NoteSearchSuccess extends NotesState {
  final List<NoteModel> notesSearchList;
  NoteSearchSuccess({required this.notesSearchList});
}

class NoteSearchEmptyData extends NotesState {}

class NoteDeleteSearch extends NotesState {}
class NoteChangePinned extends NotesState {}
