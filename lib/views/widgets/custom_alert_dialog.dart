import 'package:flutter/material.dart';
import 'package:reminder_app/utils/constants.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.dateController,
    required this.timeController,
    required this.onSelectDate,
    required this.onSelectTime,
    required this.saveReminderF,
    required this.onCancelF,
  });
  final TextEditingController dateController;
  final TextEditingController timeController;
  final void Function()? onSelectDate;
  final void Function()? onSelectTime;
  final void Function()? saveReminderF;
  final void Function()? onCancelF;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(right: 18.0, left: 18.0, top: 18.0),
      contentPadding: const EdgeInsets.all(15.0),
      backgroundColor: Colors.white,
      title: const Text('When to remind?', style: TextStyle(color: kTextColor)),
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
        // save
        MaterialButton(
          elevation: 0,
          color: kPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed:  saveReminderF,
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
  