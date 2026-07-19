import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder_app/utils/constants.dart';
import 'package:reminder_app/views/cubits/add_note_cubit/add_note_cubit.dart';
import 'package:reminder_app/views/pages/add_new_reminder_page.dart';
import 'package:reminder_app/views/pages/home_page.dart';
import 'package:reminder_app/views/pages/search_page.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  int _bottomNavIndex = 0;
  List<IconData> iconList = [Icons.settings, Icons.search_rounded];
  List<Widget> pages = [HomePage(), SearchPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: pages[_bottomNavIndex], //destination screen
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          // Navigate to add new reminder page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>  BlocProvider(
                create: (context) => AddNoteCubit(),
                child: const AddNewReminderPage(),
              ),
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
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.sharpEdge,
        leftCornerRadius: 28,
        rightCornerRadius: 28,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
    );
  }
}
