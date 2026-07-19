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
  AddNoteCubit() : super(AddNoteInitial());

  Color noteColor = colors.first;
  Color noteBorderDateColor = borderColors.first;
  static AddNoteCubit get(BuildContext context) => BlocProvider.of(context);

  void changeColor(Color color) {
    noteColor = color;
    noteBorderDateColor = borderColors[colors.indexOf(color)];
    emit(NoteChangeColor());
  }

  //int id = 0;  // id of note saved and id for reminder at the same time?
  // int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  // Add note to notes bos using hive method
  // add and delete reminder
  // add or edit function
  // Verify reminder function and schedule notification

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

    // check after schedule
    NotificationsService().getPendingNotifications();
    debugPrint('notification scheduled done for: $scheduledDate');
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     backgroundColor: Colors.green,
    //     content: Text('Reminder scheduled successfully'),
    //   ),
    // );
  }

  //  search about id
  void deleteReminder() {
    NotificationsService().cancelNotification(0);
  }

  //  data
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
   void setDate({required DateTime date}){
     selectedDate = date;
     emit(DateChanged());
   }
   void setTime({required TimeOfDay time}){
     selectedTime = time;
     emit(TimeChanged());
   }
  // note reminder data
  DateTime? reminderDate;
  // وقت النوت هوهو وقت وتاريخ ال reminder لاني بسيف تذكيرات اصلا
  String? repeatOption;
  bool hasReminder = false;
  void setReminder({required DateTime date, String? repeat}) {
    reminderDate = date;
    repeatOption = repeat;
    hasReminder = true;
    emit(ReminderChanged());
  }

// save note reminder
  void addReminder({
    required String title,
    required String content,
    required String date,
    bool? isPinned,
  }) async {
    final noteReminder = NoteModel(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      content: content,
      date: date,
      isPinned: isPinned ?? false,
      color: noteColor.toARGB32(),
      colorBorderDate: noteBorderDateColor.toARGB32(),
    );
    // add color to note
    // note.color = noteColor.toARGB32();
    // note.colorBorderDate = noteBorderDateColor.toARGB32();
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
