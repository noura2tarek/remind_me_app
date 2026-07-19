// Edit reminder dialog
// edit make it equal custom dialog
import 'package:flutter/material.dart';
import 'package:reminder_app/utils/constants.dart';

class EditReminderDialog extends StatelessWidget {
  const EditReminderDialog({
    super.key,
    required this.dateController,
    required this.timeController,
    this.onSelectDate,
    this.onSelectTime,
    this.saveReminderF,
    this.onCancelF,
    this.ondeleteReminderF,
  });

  final TextEditingController dateController;
  final TextEditingController timeController;
  final void Function()? onSelectDate;
  final void Function()? onSelectTime;
  final void Function()? saveReminderF;
  final void Function()? onCancelF;
  final void Function()? ondeleteReminderF;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(right: 18.0, left: 18.0, top: 18.0),
      contentPadding: const EdgeInsets.all(15.0),
      backgroundColor: Colors.white,
      title: const Text(
        'Edit date and time',
        style: TextStyle(color: kTextColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date text field
          TextFormField(
            readOnly: true,
            controller: dateController,
            keyboardType: TextInputType.none,
            decoration: InputDecoration(
              hintText: 'Select Date',
              labelText: dateController.text,
              fillColor: kFillColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                // show date picker
                onPressed: onSelectDate,
                icon: const Icon(Icons.calendar_today),
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Time text field
          TextFormField(
            readOnly: true,
            controller: timeController,
            keyboardType: TextInputType.none,
            decoration: InputDecoration(
              hintText: 'Select Time',
              fillColor: kFillColor,
              filled: true,
              labelText: timeController.text,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.access_time),
                // show time picker
                onPressed: onSelectTime,
              ),
            ),
          ),
        ],
      ),
      actions: [
        // cancel
        TextButton(
          onPressed: onCancelF,
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        // Delete reminder
        MaterialButton(
          elevation: 0,
          color: kPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: ondeleteReminderF,
          child: const Text(
            'Delete',
            style: TextStyle(
              color: kTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
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
