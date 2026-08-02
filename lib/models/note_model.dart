import 'package:hive/hive.dart';
part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String? content;
  @HiveField(2)
  DateTime date; // reminder date not note creation date
  @HiveField(3)
  int? color;
  @HiveField(4)
  int? colorBorderDate;
  @HiveField(5)
  bool? isPinned;
  @HiveField(6)
  final int id;
  @HiveField(7)
  String repeatOption;

  NoteModel({
    required this.title,
    required this.id,
    this.content,
    required this.date,
    this.color,
    this.isPinned = false,
    this.repeatOption = 'Does not repeat',
    this.colorBorderDate,
  });
}
