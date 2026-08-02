import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/utils/constants.dart';
import 'package:reminder_app/views/widgets/text_form_field_read.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.dateController,
    required this.timeController,
    required this.repeatController,
    required this.onSelectDate,
    required this.onSelectTime,
    required this.saveReminderF,
    required this.onCancelF,
    this.title = 'When to remind?',
    this.onChangedRepeat,
    this.repeatOption = 'Daily',
    this.onChangetime,
    this.onChangedate,
  });
  final TextEditingController dateController;
  final TextEditingController timeController;
  final TextEditingController repeatController;
  final String repeatOption;
  final void Function()? onSelectDate;
  final void Function()? onSelectTime;
  final void Function()? saveReminderF;
  final void Function()? onCancelF;
  final void Function(dynamic)? onChangedRepeat;
  final String title;
  final void Function(String)? onChangetime;
  final void Function(String)? onChangedate;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('d MMM');

    return AlertDialog(
      titlePadding: const EdgeInsets.only(right: 18.0, left: 18.0, top: 18.0),
      contentPadding: const EdgeInsets.all(15.0),
      backgroundColor: Colors.white,
      title: Text(title, style: const TextStyle(color: kTextColor)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date text field
          TextFormFieldRead(
            controller: dateController,
            onChanged: onChangedate,
            hintText: dateFormat.format(DateTime.now()),
            suffixIcon: IconButton(
              onPressed: onSelectDate,
              icon: const Icon(Icons.calendar_today),
            ),
          ),
          const SizedBox(height: 10),
          // Time text field
          TextFormFieldRead(
            controller: timeController,
            onChanged: onChangetime,
            hintText: TimeOfDay.now().format(context),
            suffixIcon: IconButton(
              onPressed: onSelectTime,
              icon: const Icon(Icons.access_time),
            ),
          ),

          // repeat option
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0),
            child: SizedBox(
              height: 45,
              child: DropdownMenuFormField(
                //  icon: const Icon(Icons.arrow_drop_down),
                dropdownMenuEntries: List.generate(repeatOptions.length, (
                  index,
                ) {
                  return DropdownMenuEntry(
                    label: repeatOptions[index],
                    value: repeatOptions[index],
                  );
                }),
                controller: repeatController,
                hintText: 'Select repeat option',
                initialSelection: repeatOption,
                keyboardType: TextInputType.text,
                onSelected: onChangedRepeat,
                inputDecorationTheme: const InputDecorationTheme(
                  fillColor: kFillColor,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: kFillColor, width: 1),
                  ),
                ),
                menuStyle: const MenuStyle(
                  side: WidgetStatePropertyAll(BorderSide.none),
                  shape: WidgetStatePropertyAll(
                    BeveledRectangleBorder(
                      borderRadius: BorderRadiusGeometry.zero,
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(kFillColor),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
      actions: [
        // cancel
        TextButton(
          onPressed: onCancelF,
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        // if (isEditingReminder)
        //   // Delete reminder
        //   TextButton(
        //     onPressed: ondeleteReminderF,
        //     child: const Text(
        //       'Delete',
        //       style: TextStyle(
        //         color: kTextColor,
        //         fontSize: 16,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //   ),
        // save
        MaterialButton(
          elevation: 0,
          color: kPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: saveReminderF,
          child: const Text(
            'Save',
            style: TextStyle(
              color: kTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
//--------------------- 
  