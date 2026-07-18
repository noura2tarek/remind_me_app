import 'package:flutter/material.dart';
import 'package:reminder_app/models/note_model.dart';

class CardItem extends StatelessWidget {
  const CardItem({super.key, required this.note});
  final NoteModel note;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      width: MediaQuery.of(context).size.width * 0.56,
      decoration: BoxDecoration(
        color: Color(0xff7dccff),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          if (note.content != null)
            Text(
              note.content ?? "",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
                height: 1.3,
              ),
            ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Color(note.colorBorderDate)),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Text(
              note.date,
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
