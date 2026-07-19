import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder_app/utils/constants.dart';
import 'package:reminder_app/views/cubits/add_note_cubit/add_note_cubit.dart';

class ColorsListView extends StatefulWidget {
  const ColorsListView({super.key});

  @override
  State<ColorsListView> createState() => _ColorsListViewState();
}

class _ColorsListViewState extends State<ColorsListView> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: colors.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return ColorItem(
          onTab: () {
            setState(() {
              selectedIndex = index;
              BlocProvider.of<AddNoteCubit>(context).noteColor =
                  colors[selectedIndex];
                BlocProvider.of<AddNoteCubit>(
                  context,
                ).changeColor(colors[selectedIndex]);
            });
          },
          isSelected: selectedIndex == index,
          color: colors[index],
        );
      },
    );
  }
}

//-----------------------
// color item circular container
class ColorItem extends StatelessWidget {
  const ColorItem({
    super.key,
    this.onTab,

    required this.isSelected,
    required this.color,
  });
  final void Function()? onTab;
  final bool isSelected;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        width: 45,
        height: 45,
        margin: const EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: color,
          border: isSelected ? Border.all(color: colors.last) : null,
        ),
        child: isSelected ? const Icon(Icons.check) : const SizedBox(),
      ),
    );
  }
}
