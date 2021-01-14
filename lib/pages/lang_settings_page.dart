import 'package:firebase_database/firebase_database.dart';
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
    final LanguagePackController _langPackController =
        watch(languagePackController);

    if (_appLang == null) {
      print('is null');
      _langPackController.updateAppLanguage();
    }
    return Container(
      color: CustomColors.mainColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: CustomColors.mainColor,
            automaticallyImplyLeading: false,
            title: Center(
              child: Consumer(
                builder: (context, watch, child) {
                  if (_appLang != null) {
                    return Text(
                      '${_appLang.selectLanguage}',
                      style: CustomTextFonts.appBarTextNormal,
                    );
                  } else {
                    return Text(
                      '',
                      style: CustomTextFonts.appBarTextNormal,
                    );
                  }
                },
              ),
            ),
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
              if (firstOpen) {
                Navigator.pushNamed(context, '/mosque');
              } else {
                Navigator.pop(context);
              }
            },
          ),
          body: Center(
            child: StreamBuilder<Event>(
              stream: _langPackController.watchLanguages(),
              builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data.snapshot.value != null) {
                  List<LanguagePack> languagePacks = [];
                  snapshot.data.snapshot.value.forEach((key, value) {
                    languagePacks.add(
                      LanguagePack.fromFirebase(value),
                    );
                  });

                  return Flex(
                    direction: Axis.vertical,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: languagePacks.length,
                          itemBuilder: (context, index) {
                            bool isSelected = false;
                            if (_appLang != null) {
                              if (languagePacks[index].languageId ==
                                  _appLang.languageId) {
                                isSelected = true;
                              }
                            }

                            String flag = languagePacks[index].flagName;
                            return LanguageItem(
                              langPackController: _langPackController,
                              flag: flag,
                              pack: languagePacks[index],
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
        ),
      ),
    );
  }
}

// FutureBuilder<List<LanguagePack>>(
//           future: _langPackController.getLanguages(),
//           builder: (BuildContext context,
//               AsyncSnapshot<List<LanguagePack>> snapshot) {
//             if (snapshot.hasData) {
//               final languageList = snapshot.data;
//               return Container(
//                 padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: languageList.length,
//                         itemBuilder: (context, index) {
//                           bool isSelected = false;
//                           if (languageList[index].languageId ==
//                               _appLang.languageId) {
//                             isSelected = true;
//                           }
//                           String flag = languageList[index].flagName;
//                           return LanguageItem(
//                             langPackController: _langPackController,
//                             flag: flag,
//                             pack: languageList[index],
//                             isSelected: isSelected,
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             } else {
//               return CircularProgressIndicator();
//             }
//           },
//         ),
