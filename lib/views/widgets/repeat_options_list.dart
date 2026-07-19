import 'package:flutter/material.dart';
import 'package:reminder_app/utils/constants.dart';
import 'package:reminder_app/views/widgets/repaet_container.dart';

class RepeatOptionsList extends StatefulWidget {
  const RepeatOptionsList({super.key});

  @override
  State<RepeatOptionsList> createState() => _RepeatOptionsListState();
}

class _RepeatOptionsListState extends State<RepeatOptionsList> {
  String? selectedRepeatOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
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
                    selectedRepeatOption = null; // unselect if already selected
                  } else {
                    selectedRepeatOption = repeatOptions[index];
                  }
                });
              },
            ),
            separatorBuilder: (context, index) => const SizedBox(width: 8),
          ),
        ),
      ],
    );
  }
}
