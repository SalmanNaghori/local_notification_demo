import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:local_notification_demo/logger.dart';

class Const {
  static DateTime parseDateString(String dateString) {
    return DateFormat('dd/MM/yyyy').parse(dateString);
  }

  static DateTime convertDateFormat(
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

  static showToast(val) {
    Fluttertoast.showToast(
        msg: val,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
