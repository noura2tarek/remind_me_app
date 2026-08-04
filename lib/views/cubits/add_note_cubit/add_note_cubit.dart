import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:remind_me/models/note_model.dart';
import 'package:remind_me/services/notifications_service.dart';
import 'package:remind_me/utils/constants.dart';
import 'package:remind_me/utils/print_state.dart';

part 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit() : super(AddNoteInitial()) {
    id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }
  late final int id;

  static AddNoteCubit get(BuildContext context) =>
      BlocProvider.of<AddNoteCubit>(context);

  Color noteColor = colors.first;
  Color noteBorderDateColor = borderColors.first;
  bool isPinned = false;
  // note reminder data
  DateTime? reminderDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();
  // وقت النوت هوهو وقت وتاريخ ال reminder لاني بسيف تذكيرات اصلا
  String? repeatOption = repeatOptions.first;

  // change pinned
  void changePinned() {
    isPinned = !isPinned;
    emit(NoteChangePinned());
  }

  void changeColor(Color color) {
    noteColor = color;
    noteBorderDateColor = borderColors[colors.indexOf(color)];
    emit(NoteChangeColor());
  }

  void setReminderDate({required DateTime date}) {
    reminderDate = date;
    emit(DateChanged());
  }

  void setReminderTime({required TimeOfDay time}) {
    selectedTime = time;
    emit(TimeChanged());
  }

  void setReminderRepeat({required String repeat}) {
    repeatOption = repeat;
    emit(RepeatChanged());
  }

  void changeReminderVar(bool value) {
    hasReminder = value;
    emit(ReminderChanged());
  }

  // Set reminder  and save it to local variables
  void setReminder({required DateTime date, String? repeat}) {
    reminderDate = date;
    repeatOption = repeat;
    hasReminder = true;
    debugPrint('reminder date $reminderDate  repeat $repeatOption ');
    emit(ReminderChanged());
  }

  // Add note to notes bos using hive method
  // add or edit function
  // Send reminder function and schedule notification
  Future<void> sendReminder({
    required String title,
    required String content,
    required int id,
  }) async {
    // send scheduled notification to user
    //  debugPrint('repeat option selected: $selectedRepeatOption');
    try {
      if (!(repeatOption == repeatOptions[0])) {
        if (repeatOption == repeatOptions[1]) {
          final timeOfDay = TimeOfDay(
            hour: reminderDate?.hour ?? 0,
            minute: reminderDate?.minute ?? 0,
          );
          await NotificationsService().sendDailyNotification(
            title: title,
            body: content,
            time: timeOfDay,
            id: id,
          );
          // emit(ReminderSent());
        } else if (repeatOption == repeatOptions[2]) {
          repeatOption = 'weekly';
          await NotificationsService().sendWeeklyNotification(
            title: title,
            body: content,
            dateTime: reminderDate ?? DateTime.now(),
            id: id,
          );
          // emit(ReminderSent());
        } else if (repeatOption == repeatOptions[3]) {
          repeatOption = 'monthly';
          await NotificationsService().sendMonthlyNotification(
            title: title,
            body: content,
            dateTime: reminderDate ?? DateTime.now(),
            id: id,
          );
          //emit(ReminderSent());
        }
      } else {
        printLog('don\'t repeat  ---- sending reminder...');
        // normal schedule without repeat
        await NotificationsService().sendScheduledNotification(
          title: title,
          body: content,
          scheduledDate: reminderDate ?? DateTime.now(),
          id: id,
        );
        printLog('notification scheduled done for: $reminderDate');
        //  emit(ReminderSent());
      }
      emit(ReminderSent());
    } catch (e) {
      printLog(e.toString());
      emit(ReminderFails());
    }
  }

  bool hasReminder = false;

  //------ Save note reminder in hive local database
  void saveReminder({
    required String title,
    required String content,
    required DateTime date,
  }) async {
    final noteReminder = NoteModel(
      id: id,
      title: title,
      content: content,
      date: date,
      isPinned: isPinned,
      repeatOption: repeatOption ?? repeatOptions.first,
      color: noteColor.toARGB32(),
      colorBorderDate: noteBorderDateColor.toARGB32(),
    );

    emit(AddNoteLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    // access notes box
    try {
      var box = Hive.box<NoteModel>(kRemindersBox);
      // add note
      await box.add(noteReminder);
      printLog('note added----');
      emit(AddNoteSuccess());
    } catch (e) {
      emit(AddNoteError(errorMsg: e.toString()));
    }
    if (reminderDate != null && hasReminder) {
      await sendReminder(
        title: noteReminder.title,
        content: noteReminder.content ?? "",
        // scheduledDate: reminderDate!,
        id: noteReminder.id,
      );
    }
  }
}
