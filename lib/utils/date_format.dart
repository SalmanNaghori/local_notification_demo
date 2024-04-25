import 'package:intl/intl.dart';
import 'package:local_notification_demo/utils/extension.dart';

class AppDateFormats {
  static const String dateFormatServer = "yyyy-MM-DDTHH:mm:ss.SSSSSSZ";
  static const String dateFormatToday = "yyyy-MM-DD HH:mm:ss.SSSSSS";
  static const String dateFormatYYYYMMSSHHMMSS = "yyyy-MM-dd HH:mm:ss";
  static const String dateFormatDDMMMMEEEE = "dd MMMM, EEEE";

  static const String dateFormatDDMMYYY = "dd/MM/yyyy";
  static const String dateFormatMDYYY = "M/dd/yyyy";
  static const String dateFormatYYYYMMDD = "yyyy/MM/dd";
  static const String dateFormatDDMMYYYYDes = "dd-MM-yyyy";
  static const String dateFormatDDMYYYY = "dd/M/yyyy";
  static const String dateFormatYYYYMDD = "yyyy-MM-dd";
  static const String dateFormatMMMMYYYY = "MMMM yyyy";
  static const String dateFormatMMYYYY = "MM/yyyy";
  static const String dateFormatDDMMM = "dd MMM";
  static const String dateFormatMMMY = "MMM y";
  static const String dateFormatMMMMY = "MMMM y";
  static const String dateFormatDD = "dd";
  static const String dateFormatMMM = "MMM";
  static const String dateFormatHHMMA = "hh:mma";
  static const String dateFormatHHMMSS = "HH:mm:ss";
  static const String dateFormatHHMM = "HH:mm";
  static const String dateFormatEE = "EE";
  static const dateFormatWithDay = "dd MMM, yyyy";
  static const dateFormatWithDayName = "dd MMM, EEEE";
}

String changeDateFormat(
    String? dateTime, String inputFormat, String outputFormat) {
  DateTime inputDate = DateTime.now();
  if (dateTime.isNotNullOrEmpty()) {
    inputDate = DateFormat(inputFormat).parse(dateTime!);
  }
  return DateFormat(outputFormat).format(inputDate);
}
