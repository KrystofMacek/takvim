import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/language_provider.dart';
import 'package:takvim/providers/mosque_provider.dart';
import '../common/constants.dart';
import '../common/styling.dart';

class LangSettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);
    // final LanguagePack _prayerLang = watch(prayerLanguagePackProvider.state);
    final LanguagePackController _langPackController = watch(
      languagePackController,
    );

    final String _mosq = watch(selectedMosque.state);

    if (_appLang == null) {
      _langPackController.updateAppLanguage();
    }
    // if (_prayerLang == null) {
    //   _langPackController.updatePrayerLanguage();
    // }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('${_appLang.select} ${_appLang.language}')),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        onPressed: () {
          final prefBox = Hive.box('pref');

          String code = LANG_MAP[_appLang.name];
          prefBox.put('appLang', code);

          bool firstOpen = prefBox.get('firstOpen');
          print('firstopen lang : $firstOpen');
          if (firstOpen) {
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: LANGUAGES.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (context, index) {
                        bool isSelected = false;
                        if (_appLang.name == LANGUAGES[index]) {
                          isSelected = true;
                        }
                        String flag = FLAG_MAP[LANGUAGES[index]];
                        return LanguageItem(
                          langPackController: _langPackController,
                          flag: flag,
                          index: index,
                          isSelected: isSelected,
                        );
                      },
                    ),
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

class LanguageItem extends StatelessWidget {
  const LanguageItem({
    Key key,
    @required LanguagePackController langPackController,
    @required this.flag,
    @required this.index,
    @required this.isSelected,
  })  : _langPackController = langPackController,
        super(key: key);

  final LanguagePackController _langPackController;
  final String flag;
  final int index;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return GestureDetector(
        onTap: () {
          String code = LANG_MAP[LANGUAGES[index]];
          Hive.box('pref').put('appLang', code);
          _langPackController.updateAppLanguage();
        },
        child: Card(
          color: Colors.blue[100],
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Flag(
                    flag,
                    height: 30,
                    width: 40,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${LANGUAGES[index]}',
                      style: CustomTextFonts.contentText,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          String code = LANG_MAP[LANGUAGES[index]];
          Hive.box('pref').put('appLang', code);
          _langPackController.updateAppLanguage();
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Flag(
                    flag,
                    height: 30,
                    width: 40,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${LANGUAGES[index]}',
                      style: CustomTextFonts.contentText,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
