import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:intl/intl.dart';
import 'package:takvim/data/models/dateBounds.dart';
import 'package:takvim/data/models/language_pack.dart';

final selectedDate = StateNotifierProvider<SelectedDate>((ref) {
  return SelectedDate();
});

class SelectedDate extends StateNotifier<DateTime> {
  SelectedDate() : super(DateTime.now());

  DatabaseReference db = FirebaseDatabase.instance.reference();

  Future<DateBounds> getDateBounds() async {
    final DataSnapshot ref = await db.child('dataBounds').once();
    DateBounds bounds = DateBounds.fromFirebase(ref.value);

    return bounds;
  }

  void updateSelectedDate(DateTime date) {
    state = date;
  }

  void onRefresh() async {
    await Future.delayed(Duration(microseconds: 500));
    state = DateTime.now();
  }

  void subsOneDay(DateTime first) {
    DateTime newDate = state.subtract(Duration(days: 1));
    if (newDate.isAfter(first) ||
        (newDate.year == first.year && newDate.day == first.day)) {
      state = newDate;
    }
  }

  void addOneDay(DateTime last) {
    DateTime newDate = state.add(Duration(days: 1));
    if (newDate.isBefore(last) ||
        (newDate.year == last.year && newDate.day == last.day)) {
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
        dayLan = languagePack.mo;
        break;
      case 'Tuesday':
        dayLan = languagePack.di;
        break;
      case 'Wednesday':
        dayLan = languagePack.mi;
        break;
      case 'Thursday':
        dayLan = languagePack.languagePackDo;
        break;
      case 'Friday':
        dayLan = languagePack.fr;
        break;
      case 'Saturday':
        dayLan = languagePack.sa;
        break;
      case 'Sunday':
        dayLan = languagePack.so;
        break;
      default:
        dayLan = '';
        break;
    }
    return dayLan;
  }
}
