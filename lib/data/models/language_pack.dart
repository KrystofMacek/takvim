// To parse this JSON data, do
//
//     final languagePack = languagePackFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LanguagePack languagePackFromJson(String str) =>
    LanguagePack.fromJson(json.decode(str));

String languagePackToJson(LanguagePack data) => json.encode(data.toJson());

class LanguagePack {
  LanguagePack({
    @required this.app,
    @required this.asr,
    @required this.dhuhr,
    @required this.di,
    @required this.languagePackDo,
    @required this.fajr,
    @required this.flagName,
    @required this.fr,
    @required this.isha,
    @required this.ishaTime,
    @required this.language,
    @required this.languageId,
    @required this.languageName,
    @required this.maghrib,
    @required this.mi,
    @required this.mo,
    @required this.mosque,
    @required this.prayerTimes,
    @required this.sa,
    @required this.sabah,
    @required this.search,
    @required this.selectLanguage,
    @required this.selectMosque,
    @required this.so,
    @required this.sunrise,
  });

  final String app;
  final String asr;
  final String dhuhr;
  final String di;
  final String languagePackDo;
  final String fajr;
  final String flagName;
  final String fr;
  final String isha;
  final String ishaTime;
  final String language;
  final String languageId;
  final String languageName;
  final String maghrib;
  final String mi;
  final String mo;
  final String mosque;
  final String prayerTimes;
  final String sa;
  final String sabah;
  final String search;
  final String selectLanguage;
  final String selectMosque;
  final String so;
  final String sunrise;

  LanguagePack copyWith({
    String app,
    String asr,
    String dhuhr,
    String di,
    String languagePackDo,
    String fajr,
    String flagName,
    String fr,
    String isha,
    String ishaTime,
    String language,
    String languageId,
    String languageName,
    String maghrib,
    String mi,
    String mo,
    String mosque,
    String prayerTimes,
    String sa,
    String sabah,
    String search,
    String selectLanguage,
    String selectMosque,
    String so,
    String sunrise,
  }) =>
      LanguagePack(
        app: app ?? this.app,
        asr: asr ?? this.asr,
        dhuhr: dhuhr ?? this.dhuhr,
        di: di ?? this.di,
        languagePackDo: languagePackDo ?? this.languagePackDo,
        fajr: fajr ?? this.fajr,
        flagName: flagName ?? this.flagName,
        fr: fr ?? this.fr,
        isha: isha ?? this.isha,
        ishaTime: ishaTime ?? this.ishaTime,
        language: language ?? this.language,
        languageId: languageId ?? this.languageId,
        languageName: languageName ?? this.languageName,
        maghrib: maghrib ?? this.maghrib,
        mi: mi ?? this.mi,
        mo: mo ?? this.mo,
        mosque: mosque ?? this.mosque,
        prayerTimes: prayerTimes ?? this.prayerTimes,
        sa: sa ?? this.sa,
        sabah: sabah ?? this.sabah,
        search: search ?? this.search,
        selectLanguage: selectLanguage ?? this.selectLanguage,
        selectMosque: selectMosque ?? this.selectMosque,
        so: so ?? this.so,
        sunrise: sunrise ?? this.sunrise,
      );

  factory LanguagePack.fromJson(Map<String, dynamic> json) => LanguagePack(
        app: json["App"],
        asr: json["Asr"],
        dhuhr: json["Dhuhr"],
        di: json["Di"],
        languagePackDo: json["Do"],
        fajr: json["Fajr"],
        flagName: json["FlagName"],
        fr: json["Fr"],
        isha: json["Isha"],
        ishaTime: json["IshaTime"],
        language: json["Language"],
        languageId: json["LanguageID"],
        languageName: json["LanguageName"],
        maghrib: json["Maghrib"],
        mi: json["Mi"],
        mo: json["Mo"],
        mosque: json["Mosque"],
        prayerTimes: json["PrayerTimes"],
        sa: json["Sa"],
        sabah: json["Sabah"],
        search: json["Search"],
        selectLanguage: json["SelectLanguage"],
        selectMosque: json["SelectMosque"],
        so: json["So"],
        sunrise: json["Sunrise"],
      );
  factory LanguagePack.fromFirebase(Map<dynamic, dynamic> json) => LanguagePack(
        app: json["App"],
        asr: json["Asr"],
        dhuhr: json["Dhuhr"],
        di: json["Di"],
        languagePackDo: json["Do"],
        fajr: json["Fajr"],
        flagName: json["FlagName"],
        fr: json["Fr"],
        isha: json["Isha"],
        ishaTime: json["IshaTime"],
        language: json["Language"],
        languageId: json["LanguageID"],
        languageName: json["LanguageName"],
        maghrib: json["Maghrib"],
        mi: json["Mi"],
        mo: json["Mo"],
        mosque: json["Mosque"],
        prayerTimes: json["PrayerTimes"],
        sa: json["Sa"],
        sabah: json["Sabah"],
        search: json["Search"],
        selectLanguage: json["SelectLanguage"],
        selectMosque: json["SelectMosque"],
        so: json["So"],
        sunrise: json["Sunrise"],
      );

  Map<String, dynamic> toJson() => {
        "App": app,
        "Asr": asr,
        "Dhuhr": dhuhr,
        "Di": di,
        "Do": languagePackDo,
        "Fajr": fajr,
        "FlagName": flagName,
        "Fr": fr,
        "Isha": isha,
        "IshaTime": ishaTime,
        "Language": language,
        "LanguageID": languageId,
        "LanguageName": languageName,
        "Maghrib": maghrib,
        "Mi": mi,
        "Mo": mo,
        "Mosque": mosque,
        "PrayerTimes": prayerTimes,
        "Sa": sa,
        "Sabah": sabah,
        "Search": search,
        "SelectLanguage": selectLanguage,
        "SelectMosque": selectMosque,
        "So": so,
        "Sunrise": sunrise,
      };
}
