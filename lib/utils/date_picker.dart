import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_notification_demo/logger.dart';
import 'package:local_notification_demo/utils/bottom_nav_button.dart';

import 'date_format.dart';

Future<String?> openCalendar(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String? outputDateFormat,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= DateTime(1900, 1);
  lastDate ??= DateTime(3000);
  if (Platform.isAndroid) {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme:
                    const ColorScheme.light(primary: Colors.deepPurpleAccent),
              ),
              child: child!);
        },
        initialDatePickerMode: DatePickerMode.day);
    if (date != null) {
      final String selectedDate = changeDateFormat(
          date.toString(),
          AppDateFormats.dateFormatToday,
          outputDateFormat ?? AppDateFormats.dateFormatDDMMYYY);
      return selectedDate;
    }
  } else {
    DateTime? selectedDateTime;
    await openCupertinoCalender(
        context: context,
        initialDate: initialDate,
        onSelect: (DateTime selectedDate) {
          logger.e(selectedDate);
          selectedDateTime = selectedDate;
        },
        maxDate: lastDate);
    if (selectedDateTime != null) {
      return changeDateFormat(selectedDateTime.toString(),
          AppDateFormats.dateFormatToday, AppDateFormats.dateFormatDDMMYYY);
    }
  }
  return null;
}

Future<DateTime?> openCupertinoCalender(
    {required DateTime initialDate,
    DateTime? minDate,
    DateTime? maxDate,
    required BuildContext context,
    required Function onSelect}) {
  // FocusScope.of(GlobalVariable.appContext).requestFocus(FocusNode());
  DateTime selectDate = initialDate;

  return showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      context: (context),
      enableDrag: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              color: Colors.transparent,
              alignment: Alignment.center,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    radius: 22,
                    child: const Icon(
                      Icons.close_rounded,
                      color: Color(0xff979c9e),
                    ),
                  )),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  // SizedBox(
                  //   height: Dimensions.h35,
                  // ),
                  // Text(
                  //   "AppString.selectPickupDate",
                  //   // style: fontStyleBold18,
                  // ),
                  Container(
                    padding: EdgeInsets.all(20),
                    height: 216,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(),
                      ),
                      child: CupertinoDatePicker(
                        onDateTimeChanged: (v) {
                          selectDate = v;
                        },
                        minimumDate: minDate,
                        maximumDate: maxDate,
                        initialDateTime: initialDate,
                        mode: CupertinoDatePickerMode.date,
                      ),
                    ),
                  ),
                  BottomNavButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onSelect(selectDate);
                      },
                      text: "done")
                ],
              ),
            ),
          ],
        );
      });
}
