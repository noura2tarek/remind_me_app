import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:reminder_app/models/note_model.dart';
import 'package:reminder_app/views/widgets/card_item.dart';

List<NoteModel> dummyUpcoimgNotes = [
  NoteModel(
    title: 'Team meeting',
    content: 'Planing Sprint log for next product design update',
    date: 'Tommorow, 11:04',
    color: 0xffFDA6C4,
    colorBorderDate: 0xffD98CA8,
  ),
  NoteModel(
    title: 'Birthday Party Prepararion',
    date: 'Sat, 6:00',
    color: 0xff1ECDC4,
    colorBorderDate: 0xff1BBDB9,
  ),
  NoteModel(
    title: 'Buy tickets for the family vacation',
    date: '4 Sep, 3:00',
    color: 0xff1ECDC4,
    colorBorderDate: 0xff1BBDB9,
  ),
  NoteModel(
    title: 'Appointment',
    content: 'Health check up with physician',
    date: '5 Sep, 5:00',
    color: 0xffFDA6C4,
    colorBorderDate: 0xffD98CA8,
  ),
];

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pinned', style: TextStyle(fontSize: 16, color: Colors.grey)),
        SizedBox(height: 8),
        // list view horizontal of pinned notes
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return CardItem(
                note: NoteModel(
                  title: 'Coffee',
                  content: 'Prepare hot coffee for friends.',
                  color: 0xff7dccff,
                  date: 'Today, 4:30',
                  colorBorderDate: 0xff4392C6,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(width: 10);
            },
            itemCount: 3,
          ),
        ),
        SizedBox(height: 20),
        Text('Upcoming', style: TextStyle(fontSize: 16, color: Colors.grey)),
        SizedBox(height: 8),
        // Staggered grid view
        Expanded(child: UpcomingRemindersList(notes: dummyUpcoimgNotes)),
      ],
    );
  }
}
///////////////////////////

class UpcomingRemindersList extends StatelessWidget {
  const UpcomingRemindersList({super.key, required this.notes});
  final List<NoteModel> notes;
  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(0),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(note.color),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (note.content != null)
                Text(
                  note.content ?? "",
                  style: TextStyle(color: Colors.black54),
                ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(note.colorBorderDate)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(note.date),
              ),
            ],
          ),
        );
      },
    );
  }
}
