import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:remind_me/bloc_observer.dart';
import 'package:remind_me/models/note_model.dart';
import 'package:remind_me/views/cubits/notes_cubit/notes_cubit.dart';
import 'package:remind_me/views/pages/layout_page.dart';
import 'package:remind_me/services/notifications_service.dart';
import 'package:remind_me/utils/constants.dart';

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
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
      ),
      home: BlocProvider(
        create: (context) => NotesCubit()..fetchNotes(),
        child: const LayoutPage(),
      ),
    );
  }
}
