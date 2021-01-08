import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/language_provider.dart';
import 'package:takvim/providers/mosque_provider.dart';
import '../common/constants.dart';
import '../common/styling.dart';
import '../widgets/language_page/language_page_widgets.dart';

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
        backgroundColor: CustomColors.mainColor,
        automaticallyImplyLeading: false,
        title: Center(
            child: Text(
          '${_appLang.selectLang}',
          style: CustomTextFonts.appBarTextNormal,
        )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: CustomColors.mainColor,
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
              return Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: LANGUAGES.length,
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
                ),
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
