// ignore_for_file: public_member_api_docs, sort_constructors_first
class SetTimeModel {
  int id;
  List<int> timeId;
  List<int> dateId;
  bool check;
  String? title;
  String? startDate, endDate;
  List<String?> setTime;
  SetTimeModel({
    required this.id,
    required this.timeId,
    required this.dateId,
    this.check = false,
    this.title,
    this.endDate,
    this.startDate,
    required this.setTime,
  });
  @override
  String toString() {
    return 'SetTimeModel(id: $id, check: $check, title: $title, startDate: $startDate, endDate: $endDate, setTime: $setTime, timeId: $timeId, dateId: $dateId)';
  }
}

class SetTime {
  int id;
  int hour;
  int minute;
  SetTime({
    required this.id,
    required this.hour,
    required this.minute,
  });
}
