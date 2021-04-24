import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/day_data.dart';
import '../providers/news_page/selected_mosque_news_provider.dart';

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

String newsNavigator(SelectedMosuqeNewsProvider provider) {
  Box prefBox = Hive.box('pref');
  final List<String> listOfMosques = prefBox.get('mosqueSubsList');

  print('news Navigator list: $listOfMosques');
  if (listOfMosques == null || listOfMosques.isEmpty) {
    prefBox.put('mosqueSubsList', <String>[]);
    return '/sub';
  } else if (listOfMosques.length == 1) {
    provider.updateSelectedMosqueNews(listOfMosques.first);
    return '/newsPage';
  } else {
    return '/newsMosquesPage';
  }
}

bool skipTime(DayData data, String time) {
  bool skip = false;
  switch (time) {
    case 'IshaTime':
      String isha = data.isha.replaceFirst(":", "");
      String ishaTime = data.ishaTime.replaceFirst(":", "");

      if (int.tryParse(ishaTime) >= int.tryParse(isha)) {
        skip = true;
      }
      break;
    case 'DhuhrTime':
      String dhuhr = data.dhuhr.replaceFirst(":", "");
      String dhuhrTime = data.dhuhrTime.replaceFirst(":", "");

      if (int.tryParse(dhuhrTime) >= int.tryParse(dhuhr)) {
        skip = true;
      }
      break;
    default:
  }

  return skip;
}
