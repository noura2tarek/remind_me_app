import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind_me/utils/constants.dart';
import 'package:remind_me/utils/functions.dart';
import 'package:remind_me/views/cubits/add_note_cubit/add_note_cubit.dart';
import 'package:remind_me/views/cubits/notes_cubit/notes_cubit.dart';
import 'package:remind_me/views/widgets/colors_list_view.dart';
import 'package:remind_me/views/widgets/custom_alert_dialog.dart';
import 'package:remind_me/views/widgets/custom_text_field.dart';


class AddNewReminderPage extends StatefulWidget {
  const AddNewReminderPage({super.key});

  @override
  State<AddNewReminderPage> createState() => _AddNewReminderPageState();
}

class _AddNewReminderPageState extends State<AddNewReminderPage> {
  // intitialze controllers
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController repeatController;
  @override
  void initState() {
    titleController = TextEditingController();
    contentController = TextEditingController();
    dateController = TextEditingController();
    dateController.text = dateFormat.format(DateTime.now());
    timeController = TextEditingController();
    repeatController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    repeatController.text =
        AddNoteCubit.get(context).repeatOption ?? repeatOptions.first;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNoteCubit, AddNoteState>(
      listener: (context, state) {
        if (state is AddNoteSuccess) {
          // close the page
          Navigator.of(context).pop();
          // call fetch notes
          NotesCubit.get(context).fetchNotes();
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
        final cubit = AddNoteCubit.get(context);
        DateTime? reminderDate = cubit.reminderDate;
        Color noteColor = cubit.noteColor;
        bool hasReminder = cubit.hasReminder;
        return Scaffold(
          backgroundColor: noteColor,
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  // save with parameter pinned boolean optional
                  cubit.changePinned();
                },
                icon: Icon(
                  cubit.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                ),
              ),
              IconButton(
                onPressed: () async {
                  // detect a remminder for this note
                  showDialogF().then((value) {
                    if (value) {
                      cubit.changeReminderVar(value);
                    }
                  });
                },
                icon: Icon(
                  hasReminder
                      ? Icons.notifications
                      : Icons.notifications_none_outlined,
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {
              DateTime? selectedDate = BlocProvider.of<AddNoteCubit>(
                context,
              ).reminderDate;

              if (!hasReminder) {
                // show snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a date for your reminder'),
                  ),
                );
                return;
              }

              //add new note in hive
              AddNoteCubit.get(context).saveReminder(
                title: titleController.text,
                content: contentController.text,
                date: selectedDate ?? DateTime.now(),
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
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                        const Icon(
                          Icons.date_range_outlined,
                          size: 25,
                          color: Colors.black45,
                        ),
                        const SizedBox(width: 7),
                        TextButton(
                          onPressed: () async {
                            // show edit dialog
                            await showDialogF();
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
    final cubit = AddNoteCubit.get(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: cubit,
          child: CustomAlertDialog(
            repeatOption: cubit.repeatOption ?? repeatOptions.first,
            onCancelF: () => Navigator.pop(dialogContext, false),
            dateController: dateController,
            timeController: timeController,
            repeatController: repeatController,
            onSelectTime: () {
              // TimeOfDay? selectedTime = AddNoteCubit.get(context).selectedTime;
              showTimePicker(
                context: dialogContext,
                initialTime: TimeOfDay.now(),
              ).then((value) {
                if (value != null) {
                  timeController.text = value.format(dialogContext);
                  // save value of time
                  cubit.setReminderTime(time: value);
                }
              });
            },
            onSelectDate: () {
              showDatePicker(
                context: dialogContext,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 5, 1, 1),
              ).then((value) {
                if (value != null) {
                  dateController.text = dateFormat.format(value);

                  if (cubit.reminderDate!.day != DateTime.now().day &&
                      cubit.reminderDate!.isBefore(DateTime.now())) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a date in the future'),
                      ),
                    );
                  } else {
                    // save value of date
                    cubit.setReminderDate(date: value);
                  }
                }
              });
            },
            saveReminderF: () {
              final selectedDate = cubit.reminderDate;
              final selectedTime = cubit.selectedTime;
              final selectedRepeatOption = cubit.repeatOption;

              // validate if date and time is selected
              if (selectedDate == null || selectedTime == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select date and time')),
                );
                return;
              }
              final scheduledDate = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
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
              cubit.setReminder(
                date: scheduledDate,
                repeat: selectedRepeatOption,
              );
              Navigator.pop(dialogContext, true);
            },
            onChangedRepeat: (value) {
              //  selectedRepeatOption = value;
              cubit.setReminderRepeat(repeat: value);
            },
          ),
        );
      },
    );

    return result ?? false;
  }

  //------------------------------------------

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
