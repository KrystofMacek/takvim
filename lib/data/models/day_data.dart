// To parse this JSON data, do
//
//     final dayData = dayDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DayData dayDataFromJson(String str) => DayData.fromJson(json.decode(str));

String dayDataToJson(DayData data) => json.encode(data.toJson());

class DayData {
  DayData({
    @required this.date,
    @required this.day,
    @required this.notes,
    @required this.fajr,
    @required this.sabah,
    @required this.sunrise,
    @required this.dhuhr,
    @required this.dhuhrTime,
    @required this.asr,
    @required this.maghrib,
    @required this.ishaTime,
    @required this.isha,
  });

  final String date;
  final String day;
  final String notes;
  final String fajr;
  final String sabah;
  final String sunrise;
  final String dhuhr;
  final String dhuhrTime;
  final String asr;
  final String maghrib;
  final String ishaTime;
  final String isha;

  DayData copyWith({
    String date,
    String day,
    String notes,
    String fajr,
    String sabah,
    String sunrise,
    String dhuhr,
    String dhuhrTime,
    String asr,
    String maghrib,
    String ishaTime,
    String isha,
  }) =>
      DayData(
        date: date ?? this.date,
        day: day ?? this.day,
        notes: notes ?? this.notes,
        fajr: fajr ?? this.fajr,
        sabah: sabah ?? this.sabah,
        sunrise: sunrise ?? this.sunrise,
        dhuhr: dhuhr ?? this.dhuhr,
        dhuhrTime: dhuhrTime ?? this.dhuhrTime,
        asr: asr ?? this.asr,
        maghrib: maghrib ?? this.maghrib,
        ishaTime: ishaTime ?? this.ishaTime,
        isha: isha ?? this.isha,
      );

  factory DayData.fromJson(Map<String, dynamic> json) => DayData(
        date: json["Date"],
        day: json["Day"],
        notes: json["Notes"],
        fajr: json["Fajr"],
        sabah: json["Sabah"],
        sunrise: json["Sunrise"],
        dhuhr: json["Dhuhr"],
        dhuhrTime: json["DhuhrTime"],
        asr: json["Asr"],
        maghrib: json["Maghrib"],
        ishaTime: json["IshaTime"],
        isha: json["Isha"],
      );

  factory DayData.fromFirebase(Map<dynamic, dynamic> json) => DayData(
        date: json["Date"],
        day: json["Day"],
        notes: json["Notes"],
        fajr: json["Fajr"],
        sabah: json["Sabah"],
        sunrise: json["Sunrise"],
        dhuhr: json["Dhuhr"],
        dhuhrTime: json["DhuhrTime"],
        asr: json["Asr"],
        maghrib: json["Maghrib"],
        ishaTime: json["IshaTime"],
        isha: json["Isha"],
      );

  Map<String, dynamic> toJson() => {
        "Date": date,
        "Day": day,
        "Notes": notes,
        "Fajr": fajr,
        "Sabah": sabah,
        "Sunrise": sunrise,
        "Dhuhr": dhuhr,
        "DhuhrTime": dhuhrTime,
        "Asr": asr,
        "Maghrib": maghrib,
        "IshaTime": ishaTime,
        "Isha": isha,
      };
}
