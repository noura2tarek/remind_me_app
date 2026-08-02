import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder_app/models/note_model.dart';
import 'package:reminder_app/utils/constants.dart';
import 'package:reminder_app/utils/functions.dart';
import 'package:reminder_app/views/cubits/edit_note/edit_note_cubit.dart';
import 'package:reminder_app/views/cubits/notes_cubit/notes_cubit.dart';
import 'package:reminder_app/views/widgets/colors_list_view.dart';
import 'package:reminder_app/views/widgets/custom_alert_dialog.dart';
import 'package:reminder_app/views/widgets/custom_text_field.dart';

class EditReminderPage extends StatefulWidget {
  const EditReminderPage({super.key, required this.note});
  final NoteModel note;
  @override
  State<EditReminderPage> createState() => _EditReminderPageState();
}

class _EditReminderPageState extends State<EditReminderPage> {
  // intitialze controllers
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController repeatController;

  @override
  void didChangeDependencies() {
    final cubit = EditNoteCubit.get(context);
    cubit.initialize(widget.note);
    repeatController.text = cubit.repeatOption;
    timeController.text = cubit.reminderTime!.format(context);
    dateController.text = dateFormat.format(
      cubit.reminderDate ?? DateTime.now(),
    );
    super.didChangeDependencies();
  }

  @override
  void initState() {
    titleController = TextEditingController();
    contentController = TextEditingController();
    dateController = TextEditingController();
    timeController = TextEditingController();
    repeatController = TextEditingController();
    repeatController.text = widget.note.repeatOption;
    titleController.text = widget.note.title;
    contentController.text = widget.note.content ?? "";
    super.initState();
  }

  Future<void> _saveNote() async {
    final cubit = EditNoteCubit.get(context);
    // if (cubit.hasReminder == false) {
    //   // notes must have reminder
    //   // show snackbar
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text('Reminder deleted')));
    // }
    await cubit.saveNote();
    // call fetch again
    await NotesCubit.get(context).fetchNotes();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = EditNoteCubit.get(context);

    return BlocBuilder<EditNoteCubit, EditNoteState>(
      builder: (context, state) {
        bool isPinned = EditNoteCubit.get(context).isPinned;
        Color noteColor = EditNoteCubit.get(context).noteColor;
        return Scaffold(
          backgroundColor: EditNoteCubit.get(context).noteColor,
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  // save with parameter pinned boolean optional
                  EditNoteCubit.get(context).changePinned();
                },
                icon: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              ),
              IconButton(
                onPressed: () async {
                  // detect a remminder for this note
                  await showDialogF();
                },
                icon: const Icon(Icons.notifications_none_outlined),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () async {
              if (cubit.reminderDate == null) {
                // show snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a date for your reminder'),
                  ),
                );
                return;
              }
              // check if data changed to avoid code with un needed cases
              await _saveNote();
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
                      child: ColorsListView(fromEdit: true),
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
                    onChanged: (value) {
                      cubit.changeTitle(value);
                    },
                  ),
                  const SizedBox(height: 5),
                  // Content text field
                  CustomTextField(
                    controller: contentController,
                    fontSize: 18,
                    maxlines: 10,
                    noteColor: noteColor,
                    hintText: 'Content',
                    onChanged: (value) {
                      cubit.changeContent(value);
                    },
                  ),
                  const SizedBox(height: 16),

                  // reminder date and time if is reminder = true
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
                          formatReminder(cubit.reminderDate!),
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
    final cubit = EditNoteCubit.get(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return CustomAlertDialog(
          repeatOption: cubit.repeatOption,
          onCancelF: () => Navigator.pop(dialogContext, false),
          dateController: dateController,
          timeController: timeController,
          repeatController: repeatController,
          // onChangetime: (value) => reminderTime = T,
          onSelectTime: () {
            showTimePicker(
              context: dialogContext,
              initialTime: cubit.reminderTime!,
            ).then((value) {
              if (value != null) {
                timeController.text = value.format(dialogContext);
                // save value of time
                // reminderTime = value;
                cubit.changeReminderTime(value);
              }
            });
          },
          onSelectDate: () {
            showDatePicker(
              context: dialogContext,
              initialDate: cubit.reminderDate!,
              firstDate: cubit.reminderDate!,
              lastDate: DateTime(DateTime.now().year + 5, 1, 1),
            ).then((value) {
              if (value != null) {
                dateController.text = dateFormat.format(value);
                // save value of date
                // cubit.reminderDate = value;
                cubit.changeReminderDate(value);
                if (cubit.reminderDate!.day != DateTime.now().day &&
                    cubit.reminderDate!.isBefore(DateTime.now())) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a date in the future'),
                    ),
                  );
                }
              }
            });
          },
          saveReminderF: () {
            // hide current snackbar
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            // validate if date and time is selected
            if (cubit.reminderDate == null || cubit.reminderTime == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select date and time')),
              );
              return;
            }
            final scheduledDate = DateTime(
              cubit.reminderDate!.year,
              cubit.reminderDate!.month,
              cubit.reminderDate!.day,
              cubit.reminderTime!.hour,
              cubit.reminderTime!.minute,
            );
            if (scheduledDate.isBefore(DateTime.now())) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select date and time in the future'),
                ),
              );
              return;
            }
            // save scheduled date reminder in local variable
            cubit.changeReminderDate(scheduledDate);
            Navigator.pop(dialogContext, true);
          },
          onChangedRepeat: (value) {
            //  repeatOption = value;
            cubit.changeRepeatOption(value);
          },
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
