import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/utils/constants.dart';
import 'package:reminder_app/views/cubits/add_note_cubit/add_note_cubit.dart';
import 'package:reminder_app/views/cubits/notes_cubit/notes_cubit.dart';
import 'package:reminder_app/views/widgets/colors_list_view.dart';
import 'package:reminder_app/views/widgets/custom_alert_dialog.dart';
import 'package:reminder_app/views/widgets/custom_text_field.dart';

class AddNewReminderPage extends StatefulWidget {
  const AddNewReminderPage({super.key});

  @override
  State<AddNewReminderPage> createState() => _AddNewReminderPageState();
}

class _AddNewReminderPageState extends State<AddNewReminderPage> {
  // intitialze controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateFormat dateFormat = DateFormat('dd/mm/yyyy');
  bool isPinned = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNoteCubit, AddNoteState>(
      listener: (context, state) {
        if (state is AddNoteSuccess) {
          // call fetch notes
          NotesCubit.get(context).fetchNotes();
          // close the page
          Navigator.of(context).pop();
          debugPrint('success add note with title ${state.title}');
        }
        if (state is AddNoteError) {
          debugPrint(state.errorMsg);
          // show message
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Error occured')));
        }
      },
      builder: (context, state) {
        DateTime? reminderDate = BlocProvider.of<AddNoteCubit>(
          context,
        ).reminderDate;
        bool hasReminder = BlocProvider.of<AddNoteCubit>(context).hasReminder;
        Color noteColor = BlocProvider.of<AddNoteCubit>(context).noteColor;
        
        return Scaffold(
          backgroundColor: noteColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () {
                  // save with parameter pinned boolean optional
                  setState(() {
                    isPinned = !isPinned;
                  });
                },
                icon: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              ),
              IconButton(
                onPressed: () {
                  // detect a remminder for this note
                  showDialogF().then((value) => hasReminder = value);
                },
                icon: const Icon(Icons.notifications_none_outlined),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {
              DateTime? selectedDate = BlocProvider.of<AddNoteCubit>(
                context,
              ).reminderDate;
              bool isreminder = BlocProvider.of<AddNoteCubit>(
                context,
              ).hasReminder;
              if (selectedDate == null || isreminder == false) {
                // show snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a date for your reminder'),
                  ),
                );
                return;
              }

              String formattedDate = formatReminder(selectedDate);
              // Navigator.of(context).pop();
              //add new note in hive
              AddNoteCubit.get(context).addReminder(
                title: titleController.text,
                content: contentController.text,
                date: formattedDate,
                isPinned: isPinned,
              );
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.check, color: kPrimaryColor, size: 35),
          ),
          bottomNavigationBar: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  offset: const Offset(1, 0),
                  color: Colors.grey[300]!,
                ),
              ],
            ),
            child: const Column(
              children: [
                Spacer(),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 16,
                      ),
                      child: ColorsListView(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add your title and description of your reminder
                  // Title text field
                  CustomTextField(
                    controller: titleController,
                    hintText: 'Title',
                    noteColor: noteColor,
                    fontSize: 20,
                  ),
                  const SizedBox(height: 5),
                  // Content text field
                  CustomTextField(
                    controller: contentController,
                    fontSize: 18,
                    maxlines: 10,
                    noteColor: noteColor,
                    hintText: 'Content',
                  ),
                  const SizedBox(height: 16),
                  // reminder date and time if is reminder = true
                  if (hasReminder == true)
                    Row(
                      children: [
                        const Icon(Icons.done_all, color: Colors.green),
                        const SizedBox(width: 7),
                        TextButton(
                          onPressed: () async {
                            // show dialog
                          //  await showEditDialogF();
                          },
                          child: Text(
                            formatReminder(reminderDate ?? DateTime.now()),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Show remind dialog
  Future<bool> showDialogF() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        // TimeOfDay? selectedTime = BlocProvider.of<AddNoteCubit>(
        //   context,
        // ).selectedTime;
        // DateTime? selectedDate = BlocProvider.of<AddNoteCubit>(
        //   context,
        // ).selectedDate;
        DateTime? selectedDate ;
        TimeOfDay? selectedTime ;
        return BlocProvider.value(
          value: AddNoteCubit.get(context),
          child: CustomAlertDialog(
            onCancelF: () => Navigator.pop(dialogContext, false),
            dateController: dateController,
            timeController: timeController,
            onSelectTime: () {
              //TimeOfDay? selectedTime = AddNoteCubit.get(context).selectedTime;
              showTimePicker(
                context: dialogContext,
                initialTime: TimeOfDay.now(),
              ).then((value) {
                if (value != null) {
                  timeController.text = value.format(dialogContext);
                  AddNoteCubit.get(context).setTime(time: value);
                   selectedTime = value; // save value of time
                }
              });
            },
            onSelectDate: () {
            //  DateTime? selectedDate = AddNoteCubit.get(context).selectedDate;
              showDatePicker(
                context: dialogContext,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 5, 1, 1),
              ).then((value) {
                if (value != null) {
                  dateController.text = dateFormat.format(value);
                     selectedDate = value; // save value of date
                  AddNoteCubit.get(context).setDate(date: value);
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
            saveReminderF: () {
              // final cubit = AddNoteCubit.get(context);
              // final selectedDate = cubit.selectedDate;
              // final selectedTime = cubit.selectedTime;
              // validate if date and time is selected
              if (selectedDate == null || selectedTime == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select date and time')),
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
                    content: Text('Please select date and time in the future'),
                  ),
                );
                return;
              }
              // save reminder in cubit only and return true
              AddNoteCubit.get(context).setReminder(
                date: scheduledDate,
                //  repeat: selectedRepeatOption,
              );
              Navigator.pop(dialogContext, true);
            },
          ),
        );
      },
    );

    return result ?? false;
  }

  // show dialog - edit reminder
  // Future<bool> showEditDialogF() async {
  //   String? selectedRepeatOption;
  //   final result = await showDialog<bool>(
  //     context: context,
  //     builder: (context) {
  //       TimeOfDay? selectedTime = BlocProvider.of<AddNoteCubit>(
  //         context,
  //       ).selectedTime;
  //       DateTime? selectedDate = BlocProvider.of<AddNoteCubit>(
  //         context,
  //       ).reminderDate;
  //       return EditReminderDialog(
  //         dateController: dateController,
  //         timeController: timeController,
  //         onSelectTime: () async {
  //           () => showTimePicker(context: context, initialTime: TimeOfDay.now())
  //               .then((value) {
  //                 if (value != null) {
  //                   timeController.text = value.format(context);
  //                   selectedTime = value; // save value of time
  //                 }
  //               });
  //         },
  //         onSelectDate: () {
  //           showDatePicker(
  //             context: context,
  //             initialDate: DateTime.now(),
  //             firstDate: DateTime.now(),
  //             lastDate: DateTime(DateTime.now().year + 5, 1, 1),
  //           ).then((value) {
  //             if (value != null) {
  //               dateController.text = dateFormat.format(value);
  //               selectedDate = value; // save value of date

  //               if (selectedDate!.day != DateTime.now().day &&
  //                   selectedDate!.isBefore(DateTime.now())) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(
  //                     content: Text('Please select a date in the future'),
  //                   ),
  //                 );
  //                 dateController.clear();
  //                 selectedDate = null;
  //               }
  //             }
  //           });
  //         },
  //         saveReminderF: () {
  //           // validate if date and time is selected
  //           if (selectedDate == null || selectedTime == null) {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(content: Text('Please select date and time')),
  //             );
  //             return;
  //           }
  //           final scheduledDate = DateTime(
  //             selectedDate!.year,
  //             selectedDate!.month,
  //             selectedDate!.day,
  //             selectedTime!.hour,
  //             selectedTime!.minute,
  //           );
  //           if (scheduledDate.isBefore(DateTime.now())) {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                 content: Text('Please select date and time in the future'),
  //               ),
  //             );
  //             return;
  //           }
  //           // save reminder in cubit only and return true
  //           BlocProvider.of<AddNoteCubit>(context).setReminder(
  //             date: scheduledDate,
  //             //  repeat: selectedRepeatOption,
  //           );
  //           Navigator.pop(context, true);
  //         },
  //         onCancelF: () => Navigator.pop(context, false),
  //         ondeleteReminderF: () {
  //           // delete reminder
  //           BlocProvider.of<AddNoteCubit>(context).deleteReminder();
  //           Navigator.pop(context, true);
  //         },
  //       );
  //     },
  //   );

  //   return result ?? false;
  // }

  //------------------------------------------

  // format reminder  -- save reminder with this format in database
  String formatReminder(DateTime reminderDate) {
    final now = DateTime.now();
    final difference = reminderDate.difference(now);

    // Past reminder
    if (difference.isNegative) {
      return DateFormat('d MMM, h:mm a').format(reminderDate);
    }

    // Less than one hour
    if (difference.inHours < 1) {
      if (difference.inMinutes <= 1) {
        return 'In 1 minute';
      }
      return 'In ${difference.inMinutes} minutes';
    }

    // equal one hour
    if (difference.inHours == 1) {
      return 'In 1 hour';
    }
    // Less than 24 hours but today
    if (_isSameDay(reminderDate, now)) {
      return 'Today, ${DateFormat('h:mm a').format(reminderDate)}';
    }

    // Tomorrow
    final tomorrow = now.add(const Duration(days: 1));
    if (_isSameDay(reminderDate, tomorrow)) {
      return 'Tomorrow, ${DateFormat('h:mm a').format(reminderDate)}';
    }

    // Other days
    return DateFormat('d MMM, h:mm a').format(reminderDate);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  dispose() {
    titleController.dispose();
    contentController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }
}

//-----------------------------------------
