import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:local_notification_demo/const/const.dart';
import 'package:local_notification_demo/logger.dart';
import 'package:local_notification_demo/model/set_time_model.dart';
import 'package:local_notification_demo/screen/widget/schedule.dart';
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
  int id = 0;

  @override
  void initState() {
    super.initState();
    if (widget.fromEdit) {
      setTimeModel = widget.setTimeModel!;
      localSetTimes.add(setTimeModel);
      id = setTimeModel.id;
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
    logger.w(AddTimerScreen.listOfSetTime.value);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ValueListenableBuilder(
        valueListenable: isDateSelected,
        builder: (_, selectedDate, __) {
          return ListView.builder(
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
                          itemBuilder: (_, ind) {
                            final selectedIsTime = listodTimer.setTime[ind];
                            return GestureDetector(
                              onTap: () {
                                // showPlatformTimePicker(context, "12:00 PM");
                                openTimePickerBottomSheet(
                                    selectedIsTime, index, ind);
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
                                                // listodTimer.setTime.add(null);
                                                if (widget.fromEdit) {
                                                  listodTimer.setTime
                                                      .removeAt(ind);
                                                  NotificationService
                                                      .cancelNotification(
                                                          listodTimer
                                                              .timeId[ind]);
                                                } else {
                                                  listodTimer.setTime
                                                      .removeAt(ind);
                                                }

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
                                                listodTimer.setTime.add(null);
                                                isDateSelected.value =
                                                    !isDateSelected.value;
                                              },
                                              child: const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                child: Icon(
                                                    Icons.add_alarm_outlined),
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
                        child: ScheduleBtn(
                          onTap: () {
                            AddTimerScreen.listOfUniqueId.clear();

                            scheduleNotification(index);
                            if (widget.fromEdit) {
                              NotificationService.cancelNotification(id);
                              widget.setTimeModel = localSetTimes[index];
                              localSetTimes.removeAt(index);
                              AddTimerScreen.listOfSetTime.notifyListeners();
                            } else {
                              localSetTimes.removeAt(index);
                              AddTimerScreen.listOfSetTime.value
                                  .add(listodTimer);
                              AddTimerScreen.listOfSetTime.notifyListeners();
                            }
                            Navigator.pop(context);
                          },
                          setTimeModel: listodTimer,
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

  void scheduleNotification(int index) {
    {
      debugPrint(
          'Notifications Scheduled for ${setTimeModel.startDate ?? ""} ${setTimeModel.endDate ?? ""} ${setTimeModel.setTime}');

      DateTime startDate = convertDateFormat(setTimeModel.startDate ?? "",
          AppDateFormats.dateFormatDDMMYYY, AppDateFormats.dateFormatYYYYMMDD);
      DateTime endDate = convertDateFormat(setTimeModel.endDate ?? "",
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
          setTimeModel.setTime[i] ?? "",
        );
      }
    }
    setTimeModel.timeId = AddTimerScreen.listOfUniqueId;
  }

  DateTime convertDateFormat(
      String inputDateString, String inputFormat, String outputFormat) {
    try {
      var inputDate = DateFormat(inputFormat).parse(inputDateString);
      var outputDate = DateFormat(outputFormat).format(inputDate);
      return DateFormat(outputFormat).parse(outputDate);
    } catch (e) {
      logger.e("Error converting date format: $e");
      return DateTime.now();
    }
  }

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
    logger.e(selectDate);

    if (selectDate != null && selecteStartDate) {
      // startDate = selectDate;
      localSetTimes[index].startDate = selectDate;
      // listOfPillReminderModel.value[index].reminderDateOrTimeModel?.endDate =
      //     null;
      isDateSelected.value = !isDateSelected.value;
    } else if (selectDate != null && selecteStartDate == false) {
      localSetTimes[index].endDate = selectDate;

      isDateSelected.value = !isDateSelected.value;
      // listOfPillReminderModel.value[index].reminderDateOrTimeModel?.endDate =
      //     selectDate;
    }
  }

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
}
