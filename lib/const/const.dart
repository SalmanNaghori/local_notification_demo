import 'package:intl/intl.dart';

class Const {
  static DateTime parseDateString(String dateString) {
    return DateFormat('dd/MM/yyyy').parse(dateString);
  }
}
