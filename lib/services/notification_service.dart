import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:local_notification_demo/logger.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../screen/add_timer_screen.dart';

class NotificationService {
  static final notificationsPlugin = FlutterLocalNotificationsPlugin();

  static init() {
    notificationsPlugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ));
    tz.initializeTimeZones();
  }

  static checkPermission() {
    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
  }

  static void scheduledNotification(
    int id,
    DateTime startDate,
    DateTime endDate,
    int hour,
    int minutes,
    String title,
    String body,
  ) async {
    var androidDetails = const AndroidNotificationDetails(
      'channel 65',
      'your channel name',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: "@mipmap/ic_launcher",
    );

    var notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    tz.initializeTimeZones();
    for (DateTime date = startDate;
        date.isBefore(endDate.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      DateTime scheduledTime =
          DateTime(date.year, date.month, date.day, hour, minutes);

      logger.e("scheduledTime=======${scheduledTime.toString()}");

      logger.d(
          'Scheduled notification for: ${DateFormat('yyyy-MM-dd HH:mm').format(scheduledTime)}');

      // If scheduled time is in the past, schedule for the next occurrence
      if (scheduledTime.isBefore(DateTime.now())) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      // Calculate the delay until the scheduled time
      int delay = scheduledTime.millisecondsSinceEpoch -
          DateTime.now().millisecondsSinceEpoch;

      // Generate a unique ID based on the date and time
      int idUnique = int.parse(
          '${scheduledTime.day}${scheduledTime.hour}${scheduledTime.minute}');
      logger.f("==idUnique ==$idUnique");
      AddTimerScreen.listOfUniqueId.add(idUnique);

      try {
        await notificationsPlugin.zonedSchedule(
          idUnique, // Unique ID for each notification
          title,
          body,
          tz.TZDateTime.now(tz.local).add(Duration(milliseconds: delay)),

          notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          //notification to trigger even if the device is in idle/doze mode
        );
      } catch (e) {
        logger.e('Error scheduling notification: $e');
        // Handle the error here as needed
      }
    }
  }

  static cancelNotification(int notificationid) async {
    logger.e("cancle the notificationid id $notificationid");
    await notificationsPlugin.cancel(notificationid);
  }
}
