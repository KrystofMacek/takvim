// To parse this JSON data, do
//
//     final languagePack = languagePackFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LanguagePack languagePackFromJson(String str) =>
    LanguagePack.fromJson(json.decode(str));

String languagePackToJson(LanguagePack data) => json.encode(data.toJson());

class LanguagePack {
  LanguagePack(
      {@required this.app,
      @required this.asr,
      @required this.dhuhr,
      @required this.fajr,
      @required this.friday,
      @required this.isha,
      @required this.ishaTime,
      @required this.language,
      @required this.maghrib,
      @required this.monday,
      @required this.mosque,
      @required this.name,
      @required this.ort,
      @required this.sabah,
      @required this.saturday,
      @required this.sunday,
      @required this.sunrise,
      @required this.takvim,
      @required this.thursday,
      @required this.tuesday,
      @required this.wednesday,
      @required this.select});

  final String app;
  final String asr;
  final String dhuhr;
  final String fajr;
  final String friday;
  final String isha;
  final String ishaTime;
  final String language;
  final String maghrib;
  final String monday;
  final String mosque;
  final String name;
  final String ort;
  final String sabah;
  final String saturday;
  final String sunday;
  final String sunrise;
  final String takvim;
  final String thursday;
  final String tuesday;
  final String wednesday;
  final String select;

  LanguagePack copyWith(
          {String app,
          String asr,
          String dhuhr,
          String fajr,
          String friday,
          String isha,
          String ishaTime,
          String language,
          String maghrib,
          String monday,
          String mosque,
          String name,
          String ort,
          String sabah,
          String saturday,
          String sunday,
          String sunrise,
          String takvim,
          String thursday,
          String tuesday,
          String wednesday,
          String select}) =>
      LanguagePack(
        app: app ?? this.app,
        asr: asr ?? this.asr,
        dhuhr: dhuhr ?? this.dhuhr,
        fajr: fajr ?? this.fajr,
        friday: friday ?? this.friday,
        isha: isha ?? this.isha,
        ishaTime: ishaTime ?? this.ishaTime,
        language: language ?? this.language,
        maghrib: maghrib ?? this.maghrib,
        monday: monday ?? this.monday,
        mosque: mosque ?? this.mosque,
        name: name ?? this.name,
        ort: ort ?? this.ort,
        sabah: sabah ?? this.sabah,
        saturday: saturday ?? this.saturday,
        sunday: sunday ?? this.sunday,
        sunrise: sunrise ?? this.sunrise,
        takvim: takvim ?? this.takvim,
        thursday: thursday ?? this.thursday,
        tuesday: tuesday ?? this.tuesday,
        wednesday: wednesday ?? this.wednesday,
        select: select ?? this.select,
      );

  factory LanguagePack.fromJson(Map<String, dynamic> json) => LanguagePack(
        app: json["App"],
        asr: json["Asr"],
        dhuhr: json["Dhuhr"],
        fajr: json["Fajr"],
        friday: json["Friday"],
        isha: json["Isha"],
        ishaTime: json["IshaTime"],
        language: json["Language"],
        maghrib: json["Maghrib"],
        monday: json["Monday"],
        mosque: json["Mosque"],
        name: json["Name"],
        ort: json["Ort"],
        sabah: json["Sabah"],
        saturday: json["Saturday"],
        sunday: json["Sunday"],
        sunrise: json["Sunrise"],
        takvim: json["Takvim"],
        thursday: json["Thursday"],
        tuesday: json["Tuesday"],
        wednesday: json["Wednesday"],
        select: json["Select"],
      );

  Map<String, dynamic> toJson() => {
        "App": app,
        "Asr": asr,
        "Dhuhr": dhuhr,
        "Fajr": fajr,
        "Friday": friday,
        "Isha": isha,
        "IshaTime": ishaTime,
        "Language": language,
        "Maghrib": maghrib,
        "Monday": monday,
        "Mosque": mosque,
        "Name": name,
        "Ort": ort,
        "Sabah": sabah,
        "Saturday": saturday,
        "Sunday": sunday,
        "Sunrise": sunrise,
        "Takvim": takvim,
        "Thursday": thursday,
        "Tuesday": tuesday,
        "Wednesday": wednesday,
        "Select": select,
      };
}
