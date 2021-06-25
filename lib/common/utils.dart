import 'package:MyMosq/common/constants.dart';
import 'package:MyMosq/common/styling.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:MyMosq/data/models/day_data.dart';
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

Color labelColoring(int index) {
  switch (index) {
    case 0:
      return NewsLabelColors.color1;
      break;
    case 1:
      return NewsLabelColors.color2;
      break;
    case 2:
      return NewsLabelColors.color3;
      break;
    case 3:
      return NewsLabelColors.color4;
      break;
    default:
      return NewsLabelColors.color5;
      break;
  }
}

// PRAYER TIME NAMES
Map<String, String> getTimeName(int index, LanguagePack lang, DayData data) {
  Map<String, String> timeName = {
    "name": '',
    "time": '',
  };
  switch (PRAYER_TIMES[index]) {
    case 'Fajr':
      timeName.update('name', (value) => lang.fajr);
      timeName.update('time', (value) => data.fajr);
      break;
    case 'Sabah':
      timeName.update('name', (value) => lang.sabah);
      timeName.update('time', (value) => data.sabah);
      break;
    case 'Sunrise':
      timeName.update('name', (value) => lang.sunrise);
      timeName.update('time', (value) => data.sunrise);
      break;
    case 'Dhuhr':
      timeName.update('name', (value) => lang.dhuhr);
      timeName.update('time', (value) => data.dhuhr);
      break;
    case 'DhuhrTime':
      timeName.update('name', (value) => lang.dhuhrTime);
      timeName.update('time', (value) => data.dhuhrTime);
      break;
    case 'Asr':
      timeName.update('name', (value) => lang.asr);
      timeName.update('time', (value) => data.asr);
      break;
    case 'Maghrib':
      timeName.update('name', (value) => lang.maghrib);
      timeName.update('time', (value) => data.maghrib);
      break;
    case 'IshaTime':
      timeName.update('name', (value) => lang.ishaTime);
      timeName.update('time', (value) => data.ishaTime);
      break;
    case 'Isha':
      timeName.update('name', (value) => lang.isha);
      timeName.update('time', (value) => data.isha);
      break;

    default:
      break;
  }

  return timeName;
}
