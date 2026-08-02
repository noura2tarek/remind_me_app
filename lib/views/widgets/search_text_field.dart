import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reminder_app/utils/constants.dart';
import 'package:reminder_app/views/cubits/notes_cubit/notes_cubit.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key, this.height});
  final double? height;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  Timer? _debounce;
  bool showClearIcon = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 46,
      child: TextFormField(
        controller: NotesCubit.get(context).searchController,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        onChanged: (value) => onChangedText(value, context),
        onFieldSubmitted: (value) {
          _debounce?.cancel();
          NotesCubit.get(context).searchNotes(value);
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: showClearIcon
              ? GestureDetector(
                  onTap: () {
                    NotesCubit.get(context).onDeleteSearchText();
                    setState(() {
                      showClearIcon = false;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                    ),
                    child: const Icon(
                      Icons.clear,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                )
              : null,
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          fillColor: kFillColor,
          filled: true,
          border: buildBorder(),
          focusedBorder: buildBorder(),
          enabledBorder: buildBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // On changed text
  void onChangedText(String text, BuildContext context) {
    setState(() {
      showClearIcon = text.isNotEmpty;
    });
    // Cancel previous timer
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (text.trim().isEmpty) {
        NotesCubit.get(context).onDeleteSearchText();
        return;
      }
      NotesCubit.get(context).searchNotes(text);
    });
  }

  // build border function
  OutlineInputBorder buildBorder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
    );
  }
}
