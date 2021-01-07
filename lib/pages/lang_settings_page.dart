import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/language_provider.dart';
import 'package:takvim/providers/mosque_provider.dart';
import '../common/constants.dart';

class LangSettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);
    final LanguagePack _prayerLang = watch(prayerLanguagePackProvider.state);
    final LanguagePackController _langPackController = watch(
      languagePackController,
    );

    final String _mosq = watch(selectedMosque.state);

    if (_appLang == null) {
      _langPackController.updateAppLanguage();
    }
    if (_prayerLang == null) {
      _langPackController.updatePrayerLanguage();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        onPressed: () {
          final prefBox = Hive.box('pref');

          String appLang = prefBox.get('appLang');
          String prayerLang = prefBox.get('prayerLang');
          String mosque = prefBox.get('mosque');

          print('BOX lang: $appLang $prayerLang $mosque');
          if (_mosq == null) {
            Navigator.pushNamed(context, '/mosque');
          } else {
            Navigator.pushNamed(context, '/home');
          }
        },
      ),
      body: Center(
        child: FutureBuilder<bool>(
          future: _langPackController.getPacks(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              String prayerLanFlag = FLAG_MAP[_prayerLang.name];
              String appLanFlag = FLAG_MAP[_appLang.name];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${_appLang.app} ${_appLang.language}'),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Flag(
                      appLanFlag,
                      height: 30,
                      width: 40,
                    ),
                  ),
                  Text('${_appLang.name}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        value: _appLang.name,
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.blue),
                        onChanged: (String newValue) {
                          String code = LANG_MAP[newValue];
                          Hive.box('pref').put('appLang', code);
                          print(Hive.box('pref').get('appLang'));
                          _langPackController.updateAppLanguage();
                        },
                        items: LANGUAGES
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text('${_appLang.takvim} ${_appLang.language}'),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Flag(
                      prayerLanFlag,
                      height: 30,
                      width: 40,
                    ),
                  ),
                  Text('${_prayerLang.name}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        value: _prayerLang.name,
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.blue),
                        onChanged: (String newValue) {
                          String code = LANG_MAP[newValue];
                          Hive.box('pref').put('prayerLang', code);
                          print(Hive.box('pref').get('prayerLang'));
                          _langPackController.updatePrayerLanguage();
                        },
                        items: LANGUAGES
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
