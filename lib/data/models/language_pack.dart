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
    @required this.minutes,
    @required this.activate,
    @required this.minutesBeforehand,
    @required this.send,
    @required this.nothingFound,
    @required this.message,
    @required this.contactUs,
    @required this.contactSuccessMessage,
    @required this.contactErrorMessage,
    @required this.formValidationEmpty,
    @required this.hijri01,
    @required this.hijri02,
    @required this.hijri03,
    @required this.hijri04,
    @required this.hijri05,
    @required this.hijri06,
    @required this.hijri07,
    @required this.hijri08,
    @required this.hijri09,
    @required this.hijri10,
    @required this.hijri11,
    @required this.hijri12,
    @required this.updateMessage,
    @required this.update,
    @required this.cancel,
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
  final String minutes;
  final String activate;
  final String minutesBeforehand;
  final String send;
  final String nothingFound;
  final String message;
  final String contactUs;
  final String contactSuccessMessage;
  final String contactErrorMessage;
  final String formValidationEmpty;
  final String hijri01;
  final String hijri02;
  final String hijri03;
  final String hijri04;
  final String hijri05;
  final String hijri06;
  final String hijri07;
  final String hijri08;
  final String hijri09;
  final String hijri10;
  final String hijri11;
  final String hijri12;
  final String updateMessage;
  final String update;
  final String cancel;

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
    String minutes,
    String activate,
    String minutesBeforehand,
    String send,
    String nothingFound,
    String message,
    String contactUs,
    String contactSuccessMessage,
    String contactErrorMessage,
    String formValidationEmpty,
    String hijri01,
    String hijri02,
    String hijri03,
    String hijri04,
    String hijri05,
    String hijri06,
    String hijri07,
    String hijri08,
    String hijri09,
    String hijri10,
    String hijri11,
    String hijri12,
    String updateMessage,
    String update,
    String cancel,
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
        minutes: minutes ?? this.minutes,

        activate: activate ?? activate,
        minutesBeforehand: minutesBeforehand ?? minutesBeforehand,
        send: send ?? send,
        nothingFound: nothingFound ?? nothingFound,
        message: message ?? message,
        contactUs: contactUs ?? contactUs,
        contactSuccessMessage: contactSuccessMessage ?? contactSuccessMessage,
        contactErrorMessage: contactErrorMessage ?? contactErrorMessage,
        formValidationEmpty: formValidationEmpty ?? formValidationEmpty,
        hijri01: hijri01 ?? this.hijri01,
        hijri02: hijri02 ?? this.hijri02,
        hijri03: hijri03 ?? this.hijri03,
        hijri04: hijri04 ?? this.hijri04,
        hijri05: hijri05 ?? this.hijri05,
        hijri06: hijri06 ?? this.hijri06,
        hijri07: hijri07 ?? this.hijri07,
        hijri08: hijri08 ?? this.hijri08,
        hijri09: hijri09 ?? this.hijri09,
        hijri10: hijri10 ?? this.hijri10,
        hijri11: hijri11 ?? this.hijri11,
        hijri12: hijri12 ?? this.hijri12,
        updateMessage: updateMessage ?? this.updateMessage,
        update: update ?? this.update,
        cancel: cancel ?? this.cancel,
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
        minutes: json["minutes"],
        activate: json["activate"],
        minutesBeforehand: json["minutesBeforehand"],
        send: json["send"],
        nothingFound: json["nothingFound"],
        message: json["message"],
        contactUs: json["contactUs"],
        contactSuccessMessage: json["contactSuccessMessage"],
        contactErrorMessage: json["contactErrorMessage"],
        formValidationEmpty: json["formValidationEmpty"],
        hijri01: json["hijri01"],
        hijri02: json["hijri02"],
        hijri03: json["hijri03"],
        hijri04: json["hijri04"],
        hijri05: json["hijri05"],
        hijri06: json["hijri06"],
        hijri07: json["hijri07"],
        hijri08: json["hijri08"],
        hijri09: json["hijri09"],
        hijri10: json["hijri10"],
        hijri11: json["hijri11"],
        hijri12: json["hijri12"],
        update: json["update"],
        cancel: json["cancel"],
        updateMessage: json["updateMessage"],
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
        minutes: json["minutes"],
        activate: json["activate"],
        minutesBeforehand: json["minutesBeforehand"],
        send: json["send"],
        nothingFound: json["nothingFound"],
        message: json["message"],
        contactUs: json["contactUs"],
        contactSuccessMessage: json["contactSuccessMessage"],
        contactErrorMessage: json["contactErrorMessage"],
        formValidationEmpty: json["formValidationEmpty"],
        hijri01: json["hijri01"],
        hijri02: json["hijri02"],
        hijri03: json["hijri03"],
        hijri04: json["hijri04"],
        hijri05: json["hijri05"],
        hijri06: json["hijri06"],
        hijri07: json["hijri07"],
        hijri08: json["hijri08"],
        hijri09: json["hijri09"],
        hijri10: json["hijri10"],
        hijri11: json["hijri11"],
        hijri12: json["hijri12"],
        update: json["update"],
        cancel: json["cancel"],
        updateMessage: json["updateMessage"],
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
        "minutes": minutes,
        "activate": activate,
        "minutesBeforehand": minutesBeforehand,
        "send": send,
        "nothingFound": nothingFound,
        "message": message,
        "contactUs": contactUs,
        "contactSuccessMessage": contactSuccessMessage,
        "contactErrorMessage": contactErrorMessage,
        "formValidationEmpty": formValidationEmpty, "hijri01": hijri01,
        "hijri02": hijri02,
        "hijri03": hijri03,
        "hijri04": hijri04,
        "hijri05": hijri05,
        "hijri06": hijri06,
        "hijri07": hijri07,
        "hijri08": hijri08,
        "hijri09": hijri09,
        "hijri10": hijri10,
        "hijri11": hijri11,
        "hijri12": hijri12,
        "update": update,
        "cancel": cancel,
        "updateMessage": updateMessage,
      };
}
