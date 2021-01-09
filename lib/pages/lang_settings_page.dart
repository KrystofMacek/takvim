import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/language_provider.dart';
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
          '${_appLang.selectLanguage}',
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

          prefBox.put('appLang', _appLang.languageId);

          bool firstOpen = prefBox.get('firstOpen');
          print('firstopen lang : $firstOpen');
          if (firstOpen) {
            Navigator.pushNamed(context, '/mosque');
          } else {
            Navigator.pop(context);
          }
        },
      ),
      body: Center(
        child: FutureBuilder<List<LanguagePack>>(
          future: _langPackController.getLanguages(),
          builder: (BuildContext context,
              AsyncSnapshot<List<LanguagePack>> snapshot) {
            if (snapshot.hasData) {
              final languageList = snapshot.data;
              return Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: languageList.length,
                        itemBuilder: (context, index) {
                          bool isSelected = false;
                          if (languageList[index].languageId ==
                              _appLang.languageId) {
                            isSelected = true;
                          }
                          String flag = languageList[index].flagName;
                          return LanguageItem(
                            langPackController: _langPackController,
                            flag: flag,
                            pack: languageList[index],
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
