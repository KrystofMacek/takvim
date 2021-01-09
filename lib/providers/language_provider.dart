import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import '../data/models/language_pack.dart';

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

final languagePackController =
    StateNotifierProvider<LanguagePackController>((ref) {
  final AppLanguagePackProvider _langPackProvider = ref.watch(
    appLanguagePackProvider,
  );
  final DatabaseReference _firebaseDatabase =
      FirebaseDatabase.instance.reference();
  return LanguagePackController(
    _langPackProvider,
    _firebaseDatabase,
  );
});

class LanguagePackController extends StateNotifier<LanguagePackController> {
  LanguagePackController(
    this._appLanguagePackProvider,
    this._firebaseDatabase,
  ) : super(null);

  AppLanguagePackProvider _appLanguagePackProvider;
  DatabaseReference _firebaseDatabase;
  // PrayerLanguagePackProvider _prayerlangPackProvider;
  final Box _prefBox = Hive.box('pref');

  Future<LanguagePack> getAppLangPack() async {
    String language = _prefBox.get('appLang');
    if (language == null) {
      _prefBox.put('appLang', '100');
      language = '100';
    }

    final DataSnapshot langSnap =
        await _firebaseDatabase.child('languages').child(language).once();

    // String lang = await rootBundle.loadString(
    //   'assets/data/languages/$language.json',
    // );

    LanguagePack newLang = LanguagePack.fromFirebase(langSnap.value);
    if (_appLanguagePackProvider == null) {
      _appLanguagePackProvider.setLang(newLang);
    }
    return newLang;
  }

  void updateAppLanguage() async {
    LanguagePack lang = await getAppLangPack();
    _appLanguagePackProvider.setLang(lang);
  }

  Future<List<LanguagePack>> getLanguages() async {
    final DataSnapshot langSnap =
        await _firebaseDatabase.child('languages').orderByKey().once();
    print('languages - ${langSnap.value.toString()}');

    List<LanguagePack> languagePacks = [];

    langSnap.value.forEach(
        (key, value) => languagePacks.add(LanguagePack.fromFirebase(value)));

    print('languages - ${languagePacks.toString()}');

    return languagePacks;
  }
}
