import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder_app/utils/constants.dart';
import 'package:reminder_app/views/cubits/add_note_cubit/add_note_cubit.dart';
import 'package:reminder_app/views/cubits/notes_cubit/notes_cubit.dart';
import 'package:reminder_app/views/pages/add_new_reminder_page.dart';
import 'package:reminder_app/views/pages/home/home_page.dart';
import 'package:reminder_app/views/pages/search_page.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  List<IconData> iconList = [Icons.notes_outlined, Icons.search_rounded];

  List<Widget> pages = [const HomePage(), const SearchPage()];
  int _currentIndex = 0;

  // Handle back pressed
  Future<bool> _handleBackPressed() async {
    // if home is selected, show exit dialog
    final bool? shouldExit = await showConfirmExitDialog(context);
    if (shouldExit ?? false) {
      await SystemNavigator.pop();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBackPressed();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        body: pages[_currentIndex], //destination screen
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            // Navigate to add new reminder page
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (contextt) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (contextt) => AddNoteCubit()),
                      BlocProvider.value(value: NotesCubit.get(context)),
                    ],
                    child: const AddNewReminderPage(),
                  );
                },
              ),
            );
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.add, color: kPrimaryColor, size: 35),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            return Icon(
              iconList[index],
              size: 24,
              color: isActive ? kPrimaryColor : kTextColor,
            );
          },
          elevation: 2,
          activeIndex: _currentIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.sharpEdge,
          leftCornerRadius: 28,
          rightCornerRadius: 28,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          //other params
        ),
      ),
    );
  }
 
 // Show confirm exit dialog
  Future<bool?> showConfirmExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
}
