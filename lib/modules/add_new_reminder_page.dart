import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/modules/widgets/repaet_container.dart';
import 'package:reminder_app/services/notifications_service.dart';

List<String> repeatOptions = ['Daily', 'Weekly', 'Monthly'];

class AddNewReminderPage extends StatefulWidget {
  const AddNewReminderPage({super.key});

  @override
  State<AddNewReminderPage> createState() => _AddNewReminderPageState();
}

class _AddNewReminderPageState extends State<AddNewReminderPage> {
  // intitialze controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateFormat dateFormat = DateFormat('yMMMMEEEEd');
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  String? selectedRepeatOption;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add New Reminder',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add your title and description of your reminder
              // title text field
              TextField(
                controller: titleController,
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // description text field
              TextField(
                controller: descriptionController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              // date text field
              TextField(
                readOnly: true,
                controller: dateController,
                keyboardType: TextInputType.none,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                onTap: () {
                  // open date picker
                  // check if date in future

                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 5, 1, 1),
                  ).then((value) {
                    if (value != null) {
                      dateController.text = dateFormat.format(value);
                      selectedDate = value; // save value of date

                      if (selectedDate!.day != DateTime.now().day &&
                          selectedDate!.isBefore(DateTime.now())) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a date in the future'),
                          ),
                        );
                        dateController.clear();
                        selectedDate = null;
                      }
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              // time text field
              TextField(
                readOnly: true,
                controller: timeController,
                keyboardType: TextInputType.none,
                decoration: InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                onTap: () {
                  // open time picker
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    if (value != null) {
                      timeController.text = value.format(context);
                      selectedTime = value; // save value of time
                    }
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Repeat reminder',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),

              // make a row of daily , weekly and monthly reminder buttons
              SizedBox(
                height: 40,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: repeatOptions.length,
                  itemBuilder: (context, index) => RepeatContainer(
                    text: repeatOptions[index],
                    isSelected: selectedRepeatOption == repeatOptions[index],
                    onTap: () {
                      setState(() {
                        if (selectedRepeatOption == repeatOptions[index]) {
                          selectedRepeatOption =
                              null; // unselect if already selected
                        } else {
                          selectedRepeatOption = repeatOptions[index];
                        }
                      });
                    },
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                ),
              ), // Add save button
              const SizedBox(height: 20),
              //------ Save / verify button
              ElevatedButton(
                onPressed: () {
                  // validate if date and time is selected
                  if (selectedDate == null || selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select date and time'),
                      ),
                    );
                    return;
                  }
                  final scheduledDate = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );
                  if (scheduledDate.isBefore(DateTime.now())) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please select date and time in the future',
                        ),
                      ),
                    );
                    return;
                  }
                  // if date and time is selected show dialog
                  // show dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Reminders App'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // text1
                            Text('title of reminder: ${titleController.text}'),
                            // text2
                            Text('Description: ${descriptionController.text}'),
                            // date and time
                            Text(
                              'date and time: ${dateController.text} ${timeController.text}',
                            ),
                            // repeat option
                            Text(
                              'repeat option: ${selectedRepeatOption ?? 'Not selected'}',
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => _verifyReminder(
                              scheduledDate,
                              selectedRepeatOption: selectedRepeatOption,
                            ),
                            child: Text('Verify'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //------------------------------------------
  // Verify reminder function and schedule notification
  void _verifyReminder(
    final DateTime scheduledDate, {
    String? selectedRepeatOption,
  }) async {
    Navigator.pop(context);
    // send scheduled notification to user
    // but finished with status UNKNOWN_TRANSACTION and parcel size 0
    debugPrint('repeat option selected: $selectedRepeatOption');
    if (selectedRepeatOption != null) {
      if (selectedRepeatOption == repeatOptions[0]) {
        final timeOfDay = TimeOfDay(
          hour: scheduledDate.hour,
          minute: scheduledDate.minute,
        );
        await NotificationsService().sendDailyNotification(
          title: titleController.text,
          body: descriptionController.text,
          time: timeOfDay,
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        );
      } else if (selectedRepeatOption == repeatOptions[1]) {
        selectedRepeatOption = 'weekly';
        await NotificationsService().sendWeeklyNotification(
          title: titleController.text,
          body: descriptionController.text,
          dateTime: scheduledDate,
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        );
      } else if (selectedRepeatOption == repeatOptions[2]) {
        selectedRepeatOption = 'monthly';
        await NotificationsService().sendMonthlyNotification(
          title: titleController.text,
          body: descriptionController.text,
          dateTime: scheduledDate,
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        );
      }
    } else {
      // normal schedule without repeat
      await NotificationsService().sendScheduledNotification(
        title: titleController.text,
        body: descriptionController.text,
        scheduledDate: scheduledDate,
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );
    }

    // check after schedule
    NotificationsService().getPendingNotifications();
    debugPrint('notification scheduled done for: $scheduledDate');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Reminder scheduled successfully'),
      ),
    );
  }

  @override
  dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
    selectedDate = null;
    selectedTime = null;
    super.dispose();
  }
}

