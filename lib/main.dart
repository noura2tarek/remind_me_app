import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reminder_app/bloc_observer.dart';
import 'package:reminder_app/models/note_model.dart';
import 'package:reminder_app/views/cubits/notes_cubit/notes_cubit.dart';
import 'package:reminder_app/views/pages/layout_page.dart';
import 'package:reminder_app/services/notifications_service.dart';
import 'package:reminder_app/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsService().init();
  await Hive.initFlutter();
  //register type adaptor
  Hive.registerAdapter(NoteModelAdapter());
  // open notes box
  await Hive.openBox<NoteModel>(kRemindersBox);
  // add bloc observer
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
      home: BlocProvider(
        create: (context) => NotesCubit()..fetchNotes(),
        child: const LayoutPage(),
      ),
    );
  }
}
