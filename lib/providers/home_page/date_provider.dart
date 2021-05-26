import 'package:MyMosq/providers/home_page/pager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:intl/intl.dart';
import 'package:MyMosq/data/models/dateBounds.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import 'package:MyMosq/providers/firestore_provider.dart';

final selectedDate = StateNotifierProvider<SelectedDate>((ref) {
  return SelectedDate(
    ref.watch(firestoreProvider),
    ref.watch(pageViewControllerProvider),
  );
});

class SelectedDate extends StateNotifier<DateTime> {
  SelectedDate(
    this._firebaseFirestore,
    this._pageViewController,
  ) : super(DateTime.now());

  DateTime get state;
  PageViewController _pageViewController;

  DatabaseReference db = FirebaseDatabase.instance.reference();
  final FirebaseFirestore _firebaseFirestore;

  Future<DateBounds> getFirestoreDateBounds() async {
    final DocumentSnapshot snap =
        await _firebaseFirestore.collection('settings').doc('calendar').get();

    DateBounds bounds = DateBounds.fromJson(snap.data());
    return bounds;
  }

  void updateSelectedDate(DateTime date) {
    state = date;
    _pageViewController.goToPage(0);
  }

  void onRefresh() async {
    await Future.delayed(Duration(microseconds: 500));
    state = DateTime.now();
    _pageViewController.goToPage(0);
  }

  void subsOneDay(DateTime first) {
    DateTime newDate = state.subtract(Duration(days: 1));
    if (newDate.isAfter(first) ||
        (newDate.year == first.year && newDate.day == first.day)) {
      state = newDate;
      _pageViewController.goToPage(0);
    }
  }

  void addOneDay(DateTime last) {
    DateTime newDate = state.add(Duration(days: 1));
    if (newDate.isBefore(last) ||
        (newDate.year == last.year && newDate.day == last.day)) {
      state = newDate;
      _pageViewController.goToPage(0);
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

  Future<String> getMoonDate(String id, LanguagePack lang) async {
    DataSnapshot snapshot = await db.child('hijriCalendar').child(id).once();
    String _val = snapshot.value;

    String y = _val.substring(0, 4);
    String m = _val.substring(4, 6);
    String d = _val.substring(6);

    String monthName = '';

    switch (m) {
      case '01':
        monthName = lang.hijri01;
        break;
      case '02':
        monthName = lang.hijri02;
        break;
      case '03':
        monthName = lang.hijri03;
        break;
      case '04':
        monthName = lang.hijri04;
        break;
      case '05':
        monthName = lang.hijri05;
        break;
      case '06':
        monthName = lang.hijri06;
        break;
      case '07':
        monthName = lang.hijri07;
        break;
      case '08':
        monthName = lang.hijri08;
        break;
      case '09':
        monthName = lang.hijri09;
        break;
      case '10':
        monthName = lang.hijri10;
        break;
      case '11':
        monthName = lang.hijri11;
        break;
      case '12':
        monthName = lang.hijri12;
        break;
      default:
        monthName = '';
    }

    String mDate = '$d. $monthName $y';

    return mDate;
  }
}
