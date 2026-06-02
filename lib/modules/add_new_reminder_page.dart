import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/services/notifications_service.dart';

// import 'package:flutter/in.dart';
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
                      // check if date in future
                      // if(selectedDate != DateTime.now()){
                      //   debugPrint('selected date: $selectedDate');
                      //  debugPrint('current date: ${DateTime.now()}');
                      // }
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

              // Add save button
              const SizedBox(height: 50),
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
                            Text('Description: ${descriptionController.text}'),
                            Text(
                              'date and time: ${dateController.text} ${timeController.text}',
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              // send scheduled notification to user

                              final scheduledDate = DateTime(
                                selectedDate!.year,
                                selectedDate!.month,
                                selectedDate!.day,
                                selectedTime!.hour,
                                selectedTime!.minute,
                              );
                              await NotificationsService()
                                  .sendScheduledNotification(
                                    title: titleController.text,
                                    body: descriptionController.text,
                                    scheduledDate: scheduledDate,
                                    id: 1,
                                  );
                              debugPrint(
                                'notification scheduled done for: $scheduledDate',
                              );
                            },
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
