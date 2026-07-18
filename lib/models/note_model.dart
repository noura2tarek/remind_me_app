import 'package:hive/hive.dart';
part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String? content;
  @HiveField(2)
  final String date;
  @HiveField(3)
  int color;
  @HiveField(4)
  int colorBorderDate;

  NoteModel({
    required this.title,
    this.content,
    required this.date,
    required this.color,
    required this.colorBorderDate,
  });
}
