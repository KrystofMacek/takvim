import 'package:intl/intl.dart';

String formatDateToID(DateTime date) {
  final dateFormat = DateFormat('yyyyMMdd');
  return dateFormat.format(date);
}

String getTwoDigitTime(int time) {
  if (time < 10) {
    return '0${DateTime.now().minute.toString()}';
  } else {
    return time.toString();
  }
}

int getStringTimeAsComparableInt(String time) =>
    int.parse(time.replaceFirst(":", ""));

String getComparableIntAsStringTime(int hours, int minutes) {
  String h = getTwoDigitTime(hours);
  String m = getTwoDigitTime(minutes);
  return '$h:$m';
}

DateTime getDateTimeOfParyer(String time) {
  List<String> hourMinute = time.split(':');
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day, int.parse(hourMinute[0]),
      int.parse(hourMinute[1]));
}
