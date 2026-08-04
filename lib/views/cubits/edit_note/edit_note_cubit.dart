import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:remind_me/models/note_model.dart';
import 'package:remind_me/services/notifications_service.dart';
import 'package:remind_me/utils/constants.dart';
part 'edit_note_state.dart';

class EditNoteCubit extends Cubit<EditNoteState> {
  EditNoteCubit() : super(EditNoteInitial());
  late NoteModel originalNote;

  late String? title;
  late String? content;
  late String repeatOption;
  late DateTime? reminderDate;
  late TimeOfDay? reminderTime;
  bool titleChanged = false;
  bool contentChanged = false;
  bool repeatChanged = false;
  bool dateChanged = false;
  bool timeChanged = false;
  // Edit note object
  static EditNoteCubit get(BuildContext context) =>
      BlocProvider.of<EditNoteCubit>(context);
  // edited note color
  Color noteColor = colors.first;
  Color noteBorderDateColor = borderColors.first;
  bool isPinned = false;
  // Intialize variables and original note
  void initialize(NoteModel note) {
    originalNote = note;
    //----
    title = note.title;
    content = note.content;
    repeatOption = note.repeatOption; //
    reminderDate = note.date; //
    reminderTime = TimeOfDay.fromDateTime(note.date);
    //hasReminder = true; // don't need this because each note must has reminder
    noteColor = Color(note.color!); //
    noteBorderDateColor = Color(note.colorBorderDate!); //
    isPinned = note.isPinned ?? false; //
  }

  // check if there are any changes
  bool get hasChanges {
    return title != originalNote.title ||
        content != originalNote.content ||
        reminderDate != originalNote.date ||
        repeatOption != originalNote.repeatOption ||
        isPinned != originalNote.isPinned ||
        noteColor.toARGB32() != originalNote.color;
  }

  void changeColor(Color color) {
    noteColor = color;
    noteBorderDateColor = borderColors[colors.indexOf(noteColor)];
    emit(NoteChangeColor());
  }

  void changeRepeatOption(String option) {
    repeatOption = option;
    repeatChanged = true;
    emit(NoteChangeRepeatOption());
  }

  void changeReminderDate(DateTime date) {
    reminderDate = date;
    dateChanged = true;
    emit(NoteChangeReminderDate());
  }

  void changeReminderTime(TimeOfDay time) {
    reminderTime = time;
    timeChanged = true;
    emit(NoteChangeReminderTime());
  }

  void changeTitle(String title) {
    this.title = title;
    titleChanged = true;
    emit(NoteChangeTitle());
  }

  void changeContent(String content) {
    this.content = content;
    contentChanged = true;
    emit(NoteChangeContent());
  }

  void changePinned() {
    isPinned = !isPinned;

    emit(NoteChangePinned());
  }

  //------ Edit note in hive and edit reminder
  Future<void> saveNote() async {
    if (hasChanges) {
      originalNote.title = title ?? originalNote.title;
      originalNote.content = content ?? originalNote.content;
      originalNote.date = reminderDate!;
      originalNote.repeatOption = repeatOption;
      originalNote.isPinned = isPinned;
      originalNote.color = noteColor.toARGB32();
      originalNote.colorBorderDate = noteBorderDateColor.toARGB32();
      // call save note -- edit note
      await originalNote.save();

      // if is pinnned or color is changed only don't call update reminder
      if (contentChanged == false &&
          titleChanged == false &&
          repeatChanged == false &&
          dateChanged == false &&
          timeChanged == false) {
        debugPrint('ediiit donee without reminder');
        return;
      }

      // call update reminder here
      await updateReminder(originalNote.id);
      debugPrint('ediiit donee');
    }
  }

  // update reminder
  Future<void> updateReminder(int id) async {
    // cancel previous notification
    await NotificationsService().cancelNotification(id);

    if (reminderDate != null) {
      await sendReminder(id: id);
    }
  }

  // Send reminder function and schedule notification -- if changed
  Future<void> sendReminder({required int id}) async {
    // send scheduled notification to user
    if (!(repeatOption == repeatOptions[0])) {
      if (repeatOption == repeatOptions[1]) {
        final timeOfDay = TimeOfDay(
          hour: reminderDate?.hour ?? 0,
          minute: reminderDate?.minute ?? 0,
        );
        await NotificationsService().sendDailyNotification(
          title: title ?? originalNote.title,
          body: content ?? originalNote.content ?? "",
          time: timeOfDay,
          id: id,
        );
      } else if (repeatOption == repeatOptions[2]) {
        repeatOption = 'weekly';
        await NotificationsService().sendWeeklyNotification(
          title: title ?? originalNote.title,
          body: content ?? originalNote.content ?? "",
          dateTime: reminderDate ?? DateTime.now(),
          id: id,
        );
      } else if (repeatOption == repeatOptions[3]) {
        repeatOption = 'monthly';
        await NotificationsService().sendMonthlyNotification(
          title: title ?? originalNote.title,
          body: content ?? originalNote.content ?? "",
          dateTime: reminderDate ?? DateTime.now(),
          id: id,
        );
      }
    } else {
      // normal schedule without repeat
      await NotificationsService().sendScheduledNotification(
        title: title ?? originalNote.title,
        body: content ?? originalNote.content ?? "",
        scheduledDate: reminderDate ?? DateTime.now(),
        id: id,
      );
    }
    emit(ReminderSent());
    debugPrint(
      'notification scheduled Edited for: $reminderDate $repeatOption',
    );
  }

  // this app does not support deleting a reminder so, we cancel the notification after deleting the note
  // Delete reminder
  // Future<void> deleteReminder(int id) async {
  //   // await NotificationsService().cancelNotification(id);
  //   // debugPrint('reminder deleted');
  //   hasReminder = false;
  //   emit(ReminderDeleted());
  // }
}
