import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/language_page/language_provider.dart';
import 'package:takvim/widgets/home_page/app_bar.dart';
import 'package:takvim/widgets/language_page/app_bar_content.dart';
import '../common/styling.dart';
import '../widgets/language_page/language_page_widgets.dart';

class LangSettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);
    final LanguagePackController _langPackController =
        watch(languagePackController);

    final size = MediaQuery.of(context).size;
    double baseSize = size.height;

    double ratio = 375 / 667;
    final double colWidth = baseSize * ratio;

    if (_appLang == null) {
      print('is null');
      _langPackController.updateAppLanguage();
    }
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(
            height: 70,
            child: LanguageAppBarContent(appLang: _appLang),
          ),
          drawer: _DrawerLangPage(
            languagePack: _appLang,
          ),
          floatingActionButton: FloatingActionButton(
            child: FaIcon(
              FontAwesomeIcons.check,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              final prefBox = Hive.box('pref');

              prefBox.put('appLang', _appLang.languageId);

              bool firstOpen = prefBox.get('firstOpen');
              if (firstOpen) {
                Navigator.pushNamed(context, '/mosque');
              } else {
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              }
            },
          ),
          body: Container(
            padding: EdgeInsets.only(top: 5),
            child: Center(
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
                    languagePacks
                        .sort((a, b) => a.languageId.compareTo(b.languageId));
                    // languagePacks.forEach((element) {
                    //   print(element.languageId);
                    // });

                    return Flex(
                      direction: Axis.vertical,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: languagePacks.length + 1,
                            itemBuilder: (context, index) {
                              bool isSelected = false;
                              if (index == languagePacks.length) {
                                return SizedBox(
                                  height: 80,
                                );
                              }
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
      ),
    );
  }
}

class _DrawerLangPage extends StatelessWidget {
  const _DrawerLangPage({
    Key key,
    LanguagePack languagePack,
  })  : _languagePack = languagePack,
        super(key: key);

  final LanguagePack _languagePack;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: FaIcon(
                    FontAwesomeIcons.bars,
                    size: 24,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  leading: FaIcon(
                    FontAwesomeIcons.mosque,
                    size: 22,
                  ),
                  title: Text('${_languagePack.selectMosque}'),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/mosque');
                  },
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  leading: FaIcon(
                    FontAwesomeIcons.globe,
                    size: 28,
                  ),
                  title: Text('${_languagePack.selectLanguage}'),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/lang');
                  },
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  leading: FaIcon(
                    FontAwesomeIcons.bell,
                    size: 28,
                  ),
                  title: Text('${_languagePack.subscribe}'),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/sub');
                  },
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  leading: Icon(
                    Icons.wb_sunny,
                    size: 28,
                  ),
                  title: Text('${_languagePack.appTheme}'),
                  onTap: () {
                    currentTheme.switchTheme(Hive.box('pref'));
                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
