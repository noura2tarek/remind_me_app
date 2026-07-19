import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:reminder_app/models/note_model.dart';
import 'package:reminder_app/services/notifications_service.dart';
import 'package:reminder_app/utils/constants.dart';
import 'package:reminder_app/views/widgets/repeat_options_list.dart';

part 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit() : super(AddNoteInitial()) {
    id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }
  late final int id;

  Color noteColor = colors.first;
  Color noteBorderDateColor = borderColors.first;
  static AddNoteCubit get(BuildContext context) =>
      BlocProvider.of<AddNoteCubit>(context);

  void changeColor(Color color) {
    noteColor = color;
    noteBorderDateColor = borderColors[colors.indexOf(color)];
    emit(NoteChangeColor());
  }

  // int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  // note reminder data
  DateTime? reminderDate;
  // وقت النوت هوهو وقت وتاريخ ال reminder لاني بسيف تذكيرات اصلا
  String? repeatOption;
  bool hasReminder = false;
  void setReminder({required DateTime date, String? repeat}) {
    reminderDate = date;
    repeatOption = repeat;
    hasReminder = true;
    //id intialized
    debugPrint('reminder date $reminderDate  repeat $repeatOption id $id');
    emit(ReminderChanged());
  }

  // Add note to notes bos using hive method
  // add or edit function
  // Send reminder function and schedule notification
  void sendReminder({
    required String title,
    required String content,
    required DateTime scheduledDate,
    required int id,
    String? selectedRepeatOption,
  }) async {
    // send scheduled notification to user
    debugPrint('repeat option selected: $selectedRepeatOption');
    if (selectedRepeatOption != null) {
      if (selectedRepeatOption == repeatOptions[0]) {
        final timeOfDay = TimeOfDay(
          hour: scheduledDate.hour,
          minute: scheduledDate.minute,
        );
        await NotificationsService().sendDailyNotification(
          title: title,
          body: content,
          time: timeOfDay,
          id: id,
        );
      } else if (selectedRepeatOption == repeatOptions[1]) {
        selectedRepeatOption = 'weekly';
        await NotificationsService().sendWeeklyNotification(
          title: title,
          body: content,
          dateTime: scheduledDate,
          id: id,
        );
      } else if (selectedRepeatOption == repeatOptions[2]) {
        selectedRepeatOption = 'monthly';
        await NotificationsService().sendMonthlyNotification(
          title: title,
          body: content,
          dateTime: scheduledDate,
          id: id,
        );
      }
    } else {
      // normal schedule without repeat
      await NotificationsService().sendScheduledNotification(
        title: title,
        body: content,
        scheduledDate: scheduledDate,
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );
    }
    // Check after schedule
    NotificationsService().getPendingNotifications();
    debugPrint('notification scheduled done for: $scheduledDate');
  }

  // Delete reminder
  Future<void> deleteReminder() async {
    await NotificationsService().cancelNotification(id);
    debugPrint('reminder deleted');
    hasReminder = false;
    emit(ReminderDeleted());
  }

  //  data
  // TimeOfDay? selectedTime;
  // DateTime? selectedDate;
  // void setDate({required DateTime date}) {
  //   selectedDate = date;
  //   emit(DateChanged());
  // }

  // void setTime({required TimeOfDay time}) {
  //   selectedTime = time;
  //   emit(TimeChanged());
  // }

  // Save note reminder
  void addReminder({
    required String title,
    required String content,
    required String date,
    bool? isPinned,
  }) async {
    final noteReminder = NoteModel(
      id: id,
      title: title,
      content: content,
      date: date,
      isPinned: isPinned ?? false,
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
      emit(AddNoteSuccess(title: noteReminder.title));
    } catch (e) {
      emit(AddNoteError(errorMsg: e.toString()));
    }
    if (hasReminder && reminderDate != null) {
      sendReminder(
        title: noteReminder.title,
        content: noteReminder.content ?? "",
        scheduledDate: reminderDate!,
        id: noteReminder.id,
      );
    }
  }
}
