import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import '../data/models/language_pack.dart';

final languagePackController =
    StateNotifierProvider<LanguagePackController>((ref) {
  final AppLanguagePackProvider _langPackProvider =
      ref.watch(appLanguagePackProvider);
  // final PrayerLanguagePackProvider _prayerlangPackProvider =
  //     ref.watch(prayerLanguagePackProvider);
  return LanguagePackController(_langPackProvider);
});

class LanguagePackController extends StateNotifier<LanguagePackController> {
  LanguagePackController(this._appLanguagePackProvider) : super(null);

  AppLanguagePackProvider _appLanguagePackProvider;
  // PrayerLanguagePackProvider _prayerlangPackProvider;
  final Box _prefBox = Hive.box('pref');

  Future<bool> getPacks() async {
    await getAppLangPack();
    // await getPrayerLangPack();

    return true;
  }

  Future<LanguagePack> getAppLangPack() async {
    String language = _prefBox.get('appLang');
    if (language == null) {
      _prefBox.put('appLang', 'en');
      language = 'en';
    }

    String lang = await rootBundle.loadString(
      'assets/data/languages/$language.json',
    );
    LanguagePack newLang = LanguagePack.fromJson(
      jsonDecode(lang),
    );
    if (_appLanguagePackProvider == null) {
      _appLanguagePackProvider.setLang(newLang);
    }
    return newLang;
  }

  void updateAppLanguage() async {
    LanguagePack lang = await getAppLangPack();
    _appLanguagePackProvider.setLang(lang);
  }

  // Future<LanguagePack> getPrayerLangPack() async {
  //   String language = _prefBox.get('prayerLang');
  //   if (language == null) {
  //     _prefBox.put('prayerLang', 'en');
  //     language = 'en';
  //   }

  //   String lang = await rootBundle.loadString(
  //     'assets/data/languages/$language.json',
  //   );
  //   LanguagePack newLang = LanguagePack.fromJson(
  //     jsonDecode(lang),
  //   );
  //   if (_prayerlangPackProvider == null) {
  //     _prayerlangPackProvider.setLang(newLang);
  //   }
  //   return newLang;
  // }

  // void updatePrayerLanguage() async {
  //   print('update _prayerlangPackProvider');
  //   LanguagePack lang = await getPrayerLangPack();
  //   print('update _prayerlangPackProvider name: ${lang.name}');
  //   print(_prayerlangPackProvider);
  //   _prayerlangPackProvider.setLang(lang);
  // }
}

// Provider of App langPack
final appLanguagePackProvider =
    StateNotifierProvider<AppLanguagePackProvider>((ref) {
  return AppLanguagePackProvider();
});

class AppLanguagePackProvider extends StateNotifier<LanguagePack> {
  AppLanguagePackProvider() : super(null);
  void setLang(LanguagePack languagePack) {
    state = languagePack;
  }
}

// // Provider of App langPack
// final prayerLanguagePackProvider =
//     StateNotifierProvider<PrayerLanguagePackProvider>((ref) {
//   return PrayerLanguagePackProvider();
// });

// class PrayerLanguagePackProvider extends StateNotifier<LanguagePack> {
//   PrayerLanguagePackProvider() : super(null);
//   void setLang(LanguagePack languagePack) {
//     state = languagePack;
//   }
// }
