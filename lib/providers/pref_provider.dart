import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';

// final prefFutureProvider = FutureProvider<Map<String, String>>((ref) async {
//   final box = await Hive.openBox('testBox');

//   String prayerLang = box.get('prayerLang');
//   String appLang = box.get('prayerLang');

//   final Map<String, String> pref = {
//     "prayerLang": prayerLang,
//     "appLang": appLang,
//   };

//   return Future.value(pref);
// });
