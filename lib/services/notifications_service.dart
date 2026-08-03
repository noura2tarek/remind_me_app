import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder_app/utils/print_state.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  // this class will be responsible for sending notifications to user
  // intialize the flutter local notifications plugin

  static final NotificationsService _instance =
      NotificationsService._internal();

  factory NotificationsService() {
    return _instance;
  }
  NotificationsService._internal();

  // local not plugin instance
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // intialize the plugin
  Future<void> init() async {
    // initialize the plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // iOS initialization
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    // settings for both platforms
    const InitializationSettings settings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: iosSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        // handle notification response
      },
    );
    // request permissions for iOS and Android 13 and above
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    // Initialize timezone to send sheduled notifications
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    debugPrint('End of init notification....');
  }

  // Send imiiediate notification
  Future<void> sendImmediateNotification({
    required String title,
    required String body,
    required int id,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Channel for reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          color: Colors.purple,
          visibility: NotificationVisibility.public,
        );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      //  payload: '',
      notificationDetails: notificationDetails,
    );
  }

  // Send scheduled notification
  Future<void> sendScheduledNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    required int id,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Channel for reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          color: Colors.purple,
          visibility: NotificationVisibility.public,
          category: AndroidNotificationCategory.alarm,
          fullScreenIntent: true,
        );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e, s) {
      printLog("Schedule Error: $e");
    }
  }

  //   Cancel notification
  // Cancel a specific notification by id
  // لو المستخدم لغي تذكير
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id: id);
  }

  // Cancel all notifications
  // لو المستخدم لغي كل التذكيرات
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Get Pending notifications/ reminders
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final List<PendingNotificationRequest> pending =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    printLog('Pending  reminder notifications: ${pending.length}');
    for (final item in pending) {
      printLog('ID: ${item.id}, Title: ${item.title}');
    }

    return pending;
  }

  // Daily notification at specific time
  Future<void> sendDailyNotification({
    required String title,
    required String body,
    required TimeOfDay time,
    required int id,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Channel for reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          color: Colors.purple,
          visibility: NotificationVisibility.public,
          category: AndroidNotificationCategory.alarm,
          // fullScreenIntent: true,
        );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(time),
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // daily
      // DateTimeComponents.time        // يوميًا
      //DateTimeComponents.dayOfWeekAndTime // أسبوعيًا
      //DateTimeComponents.dayOfMonthAndTime // شهريًا
      //DateTimeComponents.dateAndTime // سنويًا
    );
  }

  // Weekly notification
  Future<void> sendWeeklyNotification({
    required String title,
    required String body,
    required DateTime dateTime,
    required int id,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Channel for reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          color: Colors.purple,
        );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextWeeklyInstance(dateTime),
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime, // weekly
    );
  }

  // Monthly notification
  Future<void> sendMonthlyNotification({
    required String title,
    required String body,
    required DateTime dateTime,
    required int id,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Channel for reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          color: Colors.purple,
        );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,

      // i want to make it monthly notification
      scheduledDate: _nextMonthlyInstance(
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
      ),
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime, //monthly
      // the user select the date first time then, it will be repeated and scheduled for the next month with the same date and time
    );
  }

  // helper method to get next instance of time
  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Get next instance of monthly date
  tz.TZDateTime _nextMonthlyInstance(int day, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);

    int year = now.year;
    int month = now.month;

    var scheduledDate = _safeDate(year, month, day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      if (month == 12) {
        year++;
        month = 1;
      } else {
        month++;
      }

      scheduledDate = _safeDate(year, month, day, hour, minute);
    }

    return scheduledDate;
  }

  tz.TZDateTime _safeDate(int year, int month, int day, int hour, int minute) {
    final lastDayOfMonth = DateTime(year, month + 1, 0).day;

    final validDay = day > lastDayOfMonth ? lastDayOfMonth : day;

    return tz.TZDateTime(tz.local, year, month, validDay, hour, minute);
  }

  // Get next instance of weekly date
  tz.TZDateTime _nextWeeklyInstance(DateTime dateTime) {
    final scheduledDate = tz.TZDateTime.from(dateTime, tz.local);
    final now = tz.TZDateTime.now(tz.local);

    if (scheduledDate.isBefore(now)) {
      return scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }
}
