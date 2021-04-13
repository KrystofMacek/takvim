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
    @required this.address,
    @required this.app,
    @required this.appTheme,
    @required this.asr,
    @required this.contact,
    @required this.dhuhr,
    @required this.dhuhrTime,
    @required this.di,
    @required this.languagePackDo,
    @required this.email,
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
    @required this.name,
    @required this.prayerTimes,
    @required this.sa,
    @required this.sabah,
    @required this.search,
    // @required this.selectLanguage,
    // @required this.selectMosque,
    @required this.so,
    @required this.sunrise,
    @required this.telefon,
    @required this.website,
    @required this.subscribe,
    @required this.news,
    @required this.noInternet,
    @required this.compass,
    @required this.errorSensor,
    @required this.map,
    @required this.prayerTimeNotification,
  });

  final String address;
  final String app;
  final String appTheme;
  final String asr;
  final String contact;
  final String dhuhr;
  final String dhuhrTime;
  final String di;
  final String languagePackDo;
  final String email;
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
  final String name;
  final String prayerTimes;
  final String sa;
  final String sabah;
  final String search;
  // final String selectLanguage;
  // final String selectMosque;
  final String so;
  final String sunrise;
  final String telefon;
  final String website;
  final String subscribe;
  final String news;
  final String noInternet;
  final String compass;
  final String errorSensor;
  final String map;
  final String prayerTimeNotification;

  LanguagePack copyWith({
    String address,
    String app,
    String appTheme,
    String asr,
    String contact,
    String dhuhr,
    String dhuhrTime,
    String di,
    String languagePackDo,
    String email,
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
    String name,
    String prayerTimes,
    String sa,
    String sabah,
    String search,
    // String selectLanguage,
    // String selectMosque,
    String so,
    String sunrise,
    String telefon,
    String website,
    String subscribe,
    String noInternet,
    String compass,
    String errorSensor,
    String map,
    String prayerTimeNotification,
  }) =>
      LanguagePack(
        address: address ?? this.address,
        app: app ?? this.app,
        appTheme: appTheme ?? this.appTheme,
        asr: asr ?? this.asr,
        contact: contact ?? this.contact,
        dhuhr: dhuhr ?? this.dhuhr,
        dhuhrTime: dhuhrTime ?? this.dhuhrTime,
        di: di ?? this.di,
        languagePackDo: languagePackDo ?? this.languagePackDo,
        email: email ?? this.email,
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
        name: name ?? this.name,
        prayerTimes: prayerTimes ?? this.prayerTimes,
        sa: sa ?? this.sa,
        sabah: sabah ?? this.sabah,
        search: search ?? this.search,
        // selectLanguage: selectLanguage ?? this.selectLanguage,
        // selectMosque: selectMosque ?? this.selectMosque,
        so: so ?? this.so,
        sunrise: sunrise ?? this.sunrise,
        telefon: telefon ?? this.telefon,
        website: website ?? this.website,
        subscribe: subscribe ?? this.subscribe,
        news: news ?? this.news,
        noInternet: noInternet ?? this.noInternet,
        compass: compass ?? this.compass,
        errorSensor: errorSensor ?? this.errorSensor,
        map: map ?? this.map,
        prayerTimeNotification:
            prayerTimeNotification ?? this.prayerTimeNotification,
      );

  factory LanguagePack.fromJson(Map<String, dynamic> json) => LanguagePack(
        address: json["Address"],
        app: json["App"],
        appTheme: json["AppTheme"],
        asr: json["Asr"],
        contact: json["Contact"],
        dhuhr: json["Dhuhr"],
        dhuhrTime: json["DhuhrTime"],
        di: json["Di"],
        languagePackDo: json["Do"],
        email: json["Email"],
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
        name: json["Name"],
        prayerTimes: json["PrayerTimes"],
        sa: json["Sa"],
        sabah: json["Sabah"],
        search: json["Search"],
        // selectLanguage: json["SelectLanguage"],
        // selectMosque: json["SelectMosque"],
        so: json["So"],
        sunrise: json["Sunrise"],
        telefon: json["Telefon"],
        website: json["Website"],
        subscribe: json["Subscribe"],
        news: json["News"],
        noInternet: json["noInternet"],
        compass: json["Compass"],
        errorSensor: json["errorSensor"],
        map: json["map"],
        prayerTimeNotification: json["prayerTimeNotification"],
      );

  factory LanguagePack.fromFirebase(Map<dynamic, dynamic> json) => LanguagePack(
        address: json["Address"],
        app: json["App"],
        appTheme: json["AppTheme"],
        asr: json["Asr"],
        contact: json["Contact"],
        dhuhr: json["Dhuhr"],
        dhuhrTime: json["DhuhrTime"],
        di: json["Di"],
        languagePackDo: json["Do"],
        email: json["Email"],
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
        name: json["Name"],
        prayerTimes: json["PrayerTimes"],
        sa: json["Sa"],
        sabah: json["Sabah"],
        search: json["Search"],
        // selectLanguage: json["SelectLanguage"],
        // selectMosque: json["SelectMosque"],
        so: json["So"],
        sunrise: json["Sunrise"],
        telefon: json["Telefon"],
        website: json["Website"],
        subscribe: json["Subscribe"],
        news: json["News"],
        noInternet: json["noInternet"],
        compass: json["Compass"],
        errorSensor: json["errorSensor"],
        map: json["map"],
        prayerTimeNotification: json["prayerTimeNotification"],
      );

  Map<String, dynamic> toJson() => {
        "Address": address,
        "App": app,
        "AppTheme": appTheme,
        "Asr": asr,
        "Contact": contact,
        "Dhuhr": dhuhr,
        "DhuhrTime": dhuhrTime,
        "Di": di,
        "Do": languagePackDo,
        "Email": email,
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
        "Name": name,
        "PrayerTimes": prayerTimes,
        "Sa": sa,
        "Sabah": sabah,
        "Search": search,
        // "SelectLanguage": selectLanguage,
        // "SelectMosque": selectMosque,
        "So": so,
        "Sunrise": sunrise,
        "Telefon": telefon,
        "Website": website,
        "Subscribe": subscribe,
        "News": news,
        "noInternet": noInternet,
        "Compass": compass,
        "errorSensor": errorSensor,
        "map": map,
        "prayerTimeNotification": prayerTimeNotification,
      };
}
