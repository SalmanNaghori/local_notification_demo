import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_notification_demo/const/const.dart';
import 'package:local_notification_demo/logger.dart';
import 'package:local_notification_demo/model/set_time_model.dart';
import 'package:local_notification_demo/services/notification_service.dart';
import 'package:local_notification_demo/utils/custom_bottom_sheet.dart';
import 'package:local_notification_demo/utils/date_format.dart';
import 'package:local_notification_demo/utils/date_picker.dart';

class AddTimerScreen extends StatefulWidget {
  static ValueNotifier<List<SetTimeModel>> listOfSetTime = ValueNotifier([]);
  static List<int> listOfUniqueId = [];

  AddTimerScreen(
      {super.key,
      required this.title,
      this.fromEdit = false,
      this.setTimeModel});

  final String title;
  final bool fromEdit;
  SetTimeModel? setTimeModel;

  @override
  State<AddTimerScreen> createState() => _AddTimerScreenState();
}

class _AddTimerScreenState extends State<AddTimerScreen> {
  String? startDate, endDate;

  ValueNotifier<bool> isDateSelected = ValueNotifier(false);

  SetTimeModel setTimeModel = SetTimeModel(
    timeId: [],
    dateId: [],
    setTime: [],
    id: 0,
  );
  final List<SetTimeModel> localSetTimes = [];
  List<int> previousid = [];

  @override
  void initState() {
    super.initState();
    if (widget.fromEdit) {
      setTimeModel = widget.setTimeModel!;
      localSetTimes.add(setTimeModel);
      logger.e("==previous=id==${setTimeModel.timeId}");
      previousid = setTimeModel.timeId;
      logger.f("==previous=id==$previousid");
    } else {
      setTimeModel = SetTimeModel(
        dateId: [],
        timeId: [],
        id: 0,
        title: null,
        setTime: [null],
        startDate: null,
        endDate: null,
      );

      localSetTimes.add(setTimeModel);
    }
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: isDateSelected,
        builder: (_, selectedDate, __) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: localSetTimes.length,
              itemBuilder: (ctx, index) {
                final listodTimer = localSetTimes[index];
                final title = listodTimer.title ?? controller.text;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: CupertinoTextField(
                            onChanged: (value) {
                              listodTimer.title = value;
                            },
                            placeholder: "Add Label",
                            controller: TextEditingController(text: title),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          selectDate(
                            startDate,
                            index,
                            true,
                            context,
                          );
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.amber),
                          child: Center(
                              child: listodTimer.startDate != null
                                  ? Text(listodTimer.startDate ?? "")
                                  : const Text(
                                      "Click here for set start time")),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          selectDate(endDate, index, false, context);
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.amber),
                          child: Center(
                              child: listodTimer.endDate != null
                                  ? Text(listodTimer.endDate ?? "")
                                  : const Text("Click here for set End time")),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: listodTimer.setTime.length,
                          itemBuilder: (_, subIndex) {
                            final selectedIsTime =
                                listodTimer.setTime[subIndex];
                            if (widget.fromEdit) {}
                            return GestureDetector(
                              onTap: () {
                                openTimePickerBottomSheet(
                                    selectedIsTime, index, subIndex);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 15,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.amberAccent),
                                            child: Center(
                                              child: selectedIsTime != null
                                                  ? Text(
                                                      selectedIsTime.toString())
                                                  : const Text("selected time"),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                removeTime(
                                                    subIndex, listodTimer);
                                                isDateSelected.value =
                                                    !isDateSelected.value;
                                              },
                                              child: const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                child: Icon(Icons.delete),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                addTime(listodTimer);
                                                isDateSelected.value =
                                                    !isDateSelected.value;
                                              },
                                              child: const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                child: Icon(
                                                  Icons.add_alarm_outlined,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            scheduleNotificationButton(index, listodTimer);
                          },
                          child: const Text('Schedule notifications'),
                        ),
                      )
                    ],
                  ),
                );
              });
        },
      ),
    );
  }

  //schedule notifications function
  void scheduleNotification(SetTimeModel listodTimer) {
    {
      // AddTimerScreen.listOfUniqueId.clear();
      debugPrint(
          'Notifications Scheduled for ${setTimeModel.startDate ?? ""} ${setTimeModel.endDate ?? ""} ${setTimeModel.setTime}');
      DateTime startDate = Const.convertDateFormat(setTimeModel.startDate ?? "",
          AppDateFormats.dateFormatDDMMYYY, AppDateFormats.dateFormatYYYYMMDD);
      DateTime endDate = Const.convertDateFormat(setTimeModel.endDate ?? "",
          AppDateFormats.dateFormatDDMMYYY, AppDateFormats.dateFormatYYYYMMDD);
      for (int i = 0; i < setTimeModel.setTime.length; i++) {
        int hour = int.parse(setTimeModel.setTime[i]!.split(":")[0]);
        int minutes = int.parse(setTimeModel.setTime[i]!.split(":")[1]);
        NotificationService.scheduledNotification(
            setTimeModel.id,
            startDate,
            endDate,
            hour,
            minutes,
            setTimeModel.title ?? "",
            setTimeModel.setTime[i] ?? "", (int id) {
          listodTimer.timeId.add(id);
        });
      }
    }
  }

  //Todo: previous notifications
  Future<void> cancelAllNotifications() async {
    logger.f("previous ids$previousid");
    for (int i = 0; i < previousid.length; i++) {
      NotificationService.cancelNotification(previousid[i]);
    }
  }

  //todo: select time function
  selectDate(
    String? selectDate,
    int index,
    bool selecteStartDate,
    BuildContext context,
  ) async {
    selectDate = await openCalendar(context,
        initialDate: selectDate != null
            ? Const.parseDateString(selectDate)
            : DateTime.now(),
        firstDate: DateTime.now());
    if (selectDate != null && selecteStartDate) {
      localSetTimes[index].startDate = selectDate;

      isDateSelected.value = !isDateSelected.value;
    } else if (selectDate != null && selecteStartDate == false) {
      localSetTimes[index].endDate = selectDate;
      isDateSelected.value = !isDateSelected.value;
    }
  }

  // Todo:Select Date function
  Future<void> openTimePickerBottomSheet(
    String? selectedTime,
    int index,
    ind,
  ) async {
    final time = selectedTime != null
        ? DateFormat("HH:mm").parse(selectedTime)
        : DateTime.now();
    var selectedDocTime = '';

    await CustomBottomSheet.instance.modalBottomSheet(
      bottomButtonName: "save",
      bottomButtonColor: Colors.amber,
      context: context,
      child: SizedBox(
        height: 220,
        child: CupertinoDatePicker(
          use24hFormat: false,
          mode: CupertinoDatePickerMode.time,
          initialDateTime: time,
          onDateTimeChanged: (DateTime newDateTime) {
            selectedDocTime = newDateTime.toString();
          },
        ),
      ),
      onBottomPressed: () {
        selectedTime = changeDateFormat(
          selectedDocTime.toString(),
          AppDateFormats.dateFormatToday,
          AppDateFormats.dateFormatHHMM,
        ).toLowerCase();
        // listOfPillReminderModel.value[index].reminderDateOrTimeModel
        //     ?.selectTime[ind] = selectedTime;
        localSetTimes[index].setTime[ind] = selectedTime;
        isDateSelected.value = !isDateSelected.value;

        Navigator.pop(context);
      },
    );
  }

  // Todo: Remove time function
  void removeTime(int subIndex, SetTimeModel listodTimer) {
    if (widget.fromEdit) {
      if (subIndex != 0) {
        listodTimer.setTime.removeAt(subIndex);
        NotificationService.cancelNotification(listodTimer.timeId[subIndex]);
      } else {
        Const.showToast("one time filed is required");
      }
    } else {
      if (subIndex != 0) {
        listodTimer.setTime.removeAt(subIndex);
      } else {
        Const.showToast("one time filed is required");
      }
    }
  }

  //Todo:Add Time
  void addTime(SetTimeModel listodTimer) {
    listodTimer.setTime.add(null);
  }

  Future<void> scheduleNotificationButton(
      int index, SetTimeModel listodTimer) async {
    if (widget.fromEdit) {
      cancelAllNotifications();
      listodTimer.timeId.clear();
      await Future.delayed(const Duration(milliseconds: 100), () {
        scheduleNotification(listodTimer);
      });
      widget.setTimeModel = listodTimer;
      localSetTimes.removeAt(index);
      AddTimerScreen.listOfSetTime.notifyListeners();
    } else {
      await Future.delayed(const Duration(milliseconds: 100), () {
        scheduleNotification(listodTimer);
      });
      localSetTimes.removeAt(index);
      AddTimerScreen.listOfSetTime.value.add(listodTimer);
      AddTimerScreen.listOfSetTime.notifyListeners();
    }
    Navigator.pop(context);
  }
}
