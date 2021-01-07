import 'package:flutter_riverpod/all.dart';
import 'package:intl/intl.dart';
import 'package:takvim/data/models/language_pack.dart';

final selectedDate = StateNotifierProvider<SelectedDate>((ref) {
  return SelectedDate();
});

class SelectedDate extends StateNotifier<DateTime> {
  SelectedDate() : super(DateTime.now());

  void updateSelectedDate(DateTime date) {
    state = date;
  }

  void subsOneDay() {
    DateTime newDate = state.subtract(Duration(days: 1));
    if (newDate.year == DateTime.now().year) {
      state = newDate;
    }
  }

  void addOneDay() {
    DateTime newDate = state.add(Duration(days: 1));
    if (newDate.year == DateTime.now().year) {
      state = newDate;
    }
  }

  String getDateId() {
    final dateFormat = DateFormat('yyyyMMdd');
    return dateFormat.format(state);
  }

  String getDateFormatted() {
    final dateFormat = DateFormat('dd.MM.yyyy');
    return dateFormat.format(state);
  }

  String getDayOfTheWeek(LanguagePack languagePack) {
    final String day = DateFormat('EEEE').format(state);
    String dayLan = '';
    switch (day) {
      case 'Monday':
        dayLan = languagePack.monday;
        break;
      case 'Tuesday':
        dayLan = languagePack.tuesday;
        break;
      case 'Wednesday':
        dayLan = languagePack.wednesday;
        break;
      case 'Thursday':
        dayLan = languagePack.thursday;
        break;
      case 'Friday':
        dayLan = languagePack.friday;
        break;
      case 'Saturday':
        dayLan = languagePack.saturday;
        break;
      case 'Sunday':
        dayLan = languagePack.sunday;
        break;
      default:
        dayLan = '';
        break;
    }
    return dayLan;
  }
}
