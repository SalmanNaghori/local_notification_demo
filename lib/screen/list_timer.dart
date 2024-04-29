import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:local_notification_demo/logger.dart';
import 'package:local_notification_demo/model/set_time_model.dart';
import 'package:local_notification_demo/screen/add_timer_screen.dart';
import 'package:local_notification_demo/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ListOfTimer extends StatefulWidget {
  const ListOfTimer({super.key});

  @override
  State<ListOfTimer> createState() => _ListOfTimerState();
}

class _ListOfTimerState extends State<ListOfTimer> {
  List<AlarmSettings>? alarms;

  static StreamSubscription<AlarmSettings>? subscription;
  @override
  void initState() {
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }

    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => stopAlarm(alarmSettings),
    );
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted.',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    alarmPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      alarmPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      alarmPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms?.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  Future<void> stopAlarm(AlarmSettings alarmSettings) async {
    Alarm.stop(alarmSettings.id);
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) =>
    //         ExampleAlarmRingScreen(alarmSettings: alarmSettings),
    //   ),
    // );
    loadAlarms();
  }

  ValueNotifier<bool> isDateSelected = ValueNotifier(false);

  SetTimeModel setTimeModel = SetTimeModel(
    id: 0,
    timeId: [],
    dateId: [],
    setTime: [],
  );
  @override
  Widget build(BuildContext context) {
    logger.w(AddTimerScreen.listOfSetTime.value);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTimer();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
      ),
      body: ValueListenableBuilder(
          valueListenable: AddTimerScreen.listOfSetTime,
          builder: (_, selectedDate, __) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: AddTimerScreen.listOfSetTime.value.length,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      gotoAddTimersScreen(
                          AddTimerScreen.listOfSetTime.value[index], true);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.orangeAccent,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AddTimerScreen.listOfSetTime.value[index].title ??
                                "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          "${AddTimerScreen.listOfSetTime.value[index].startDate}"),
                                      Text(
                                          "  ${AddTimerScreen.listOfSetTime.value[index].endDate}"),
                                    ],
                                  ),
                                ],
                              ),
                              GestureDetector(
                                  onTap: () {
                                    removeTimer(index);
                                  },
                                  child: const Icon(Icons.delete)),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: AddTimerScreen
                                .listOfSetTime.value[index].setTime.length,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, subIndex) {
                              // Access each item in the list and create a Text widget for it
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AddTimerScreen.listOfSetTime.value[index]
                                            .setTime[subIndex] ??
                                        "",
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }

  void addTimer() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddTimerScreen(title: "Add Timer")));

    // MyHomePage.listOfSetTime.value.add(setTimeModel);
    logger.w(AddTimerScreen.listOfSetTime);
    isDateSelected.value = !isDateSelected.value;
  }

  removeTimer(int index) {
    NotificationService.cancelNotification(
        AddTimerScreen.listOfSetTime.value[index].id);
    AddTimerScreen.listOfSetTime.value.removeAt(index);
    AddTimerScreen.listOfSetTime.notifyListeners();
  }

  gotoAddTimersScreen(SetTimeModel setTimeModel, bool editThis) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddTimerScreen(
                  title: "Add Timer",
                  fromEdit: true,
                  setTimeModel: setTimeModel,
                )));
  }
}
