import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification_demo/logger.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
    if (Alarm.android) {
      notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    } else {
      notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  static void scheduledNotification(
    DateTime selectedTime,
    DateTime startDate,
    DateTime endDate,
    int hour,
    int minutes,
    String title,
    String body,
    Function getId,
  ) async {
    var androidDetails = const AndroidNotificationDetails(
      'channel 65',
      'your channel name',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: "@mipmap/ic_launcher",
    );

    // var notificationDetails = NotificationDetails(
    //   android: androidDetails,
    // );

    tz.initializeTimeZones();
    for (DateTime date = startDate;
        date.isBefore(endDate.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      // DateTime scheduledTime = DateTime(
      //   date.year,
      //   date.month,
      //   date.day,
      //   hour,
      //   minutes,
      // );

      //
      final DateTime now = DateTime.now();
      selectedTime = now.copyWith(
        year: date.year,
        month: date.month,
        day: date.day,
        hour: hour,
        minute: minutes,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
      if (selectedTime.isBefore(now)) {
        selectedTime = selectedTime.add(const Duration(days: 1));
      }

      // if (scheduledTime.isBefore(DateTime.now())) {
      //   scheduledTime = scheduledTime.add(const Duration(days: 1));
      // }

      // int delay = scheduledTime.millisecondsSinceEpoch -
      //     DateTime.now().millisecondsSinceEpoch;

      int idUnique = int.parse(
          '${selectedTime.day}${selectedTime.hour}${selectedTime.minute}');

      getId(idUnique);
      try {
        // await notificationsPlugin.zonedSchedule(
        //   idUnique, // Unique ID for each notification
        //   title,
        //   body,
        //   tz.TZDateTime.now(tz.local).add(Duration(milliseconds: delay)),

        //   notificationDetails,
        //   uiLocalNotificationDateInterpretation:
        //       UILocalNotificationDateInterpretation.absoluteTime,
        //   androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // );

        final alarmSetting = AlarmSettings(
          id: idUnique,
          dateTime: selectedTime,
          loopAudio: true,
          vibrate: true,
          assetAudioPath: 'assets/audio/marimba.mp3',
          notificationTitle: title,
          notificationBody: 'Your alarm ($idUnique) is ringing $body',
        );
        Alarm.set(alarmSettings: alarmSetting);
      } catch (e) {
        logger.e('Error scheduling notification: $e');
      }
    }
  }

  static cancelNotification(int notificationid) async {
    logger.e("cancle the notificationid id $notificationid");
    await notificationsPlugin.cancel(notificationid);
  }
}
