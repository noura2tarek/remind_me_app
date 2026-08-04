import 'package:flutter/material.dart';
import 'package:reminder_app/models/note_model.dart';
import 'package:reminder_app/utils/functions.dart';
import 'package:reminder_app/views/cubits/notes_cubit/notes_cubit.dart';

// -------- Base Note Item ---------//

class NoteItem extends StatelessWidget {
  const NoteItem({
    super.key,
    required this.note,
    this.inGrid = false,
    this.fromSearch = false,
    this.onLongPress,
    this.onTap,
  });
  final NoteModel note;
  final bool inGrid;
  final bool fromSearch;
  final void Function()? onLongPress;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //show dialog on log press to edit or delete
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        constraints: !inGrid ? const BoxConstraints(minHeight: 129) : null,
        padding: EdgeInsets.all(fromSearch ? 10 : 11),
        width: !inGrid ? MediaQuery.of(context).size.width * 0.50 : null,

        decoration: BoxDecoration(
          color: Color(note.color ?? 0xff000000),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: inGrid ? MainAxisSize.min : MainAxisSize.max,
          children: [
            !inGrid
                ? Row(
                    children: [
                      Expanded(
                        child: Text(
                          note.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // change pin icon
                      GestureDetector(
                        onTap: () {
                          NotesCubit.get(context).changePinStatus(note);
                        },
                        child: const Icon(
                          Icons.push_pin_rounded,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  )
                : Text(
                    note.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            const SizedBox(height: 6),
            if (note.content == null) ...[const Spacer()],
            if (note.content != null) ...[
              !inGrid
                  ? Expanded(
                      child: Text(
                        note.content ?? "",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                          height: !inGrid ? 1.1 : null,
                        ),
                      ),
                    )
                  : Text(
                      note.content ?? "",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        height: !inGrid ? 1.1 : null,
                      ),
                    ),
              const SizedBox(height: 10),
            ],
            // Date
            Container(
              padding: !inGrid
                  ? const EdgeInsets.symmetric(horizontal: 8, vertical: 2)
                  : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(note.colorBorderDate ?? 0xffffffff),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Text(
                formatReminder(note.date),
                style: const TextStyle(color: Colors.black54, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
