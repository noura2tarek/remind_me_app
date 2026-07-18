import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/bloc_observer.dart';
import 'package:reminder_app/views/pages/layout_page.dart';
import 'package:reminder_app/services/notifications_service.dart';
import 'package:reminder_app/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsService().init();
  Bloc.observer = MyBlocObserver();
  runApp(const ReminderApp());
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      title: 'ذكّرني',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
      ),
      home: const LayoutPage(),
    );
  }
}
