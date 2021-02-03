import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/date_provider.dart';
import 'package:takvim/providers/language_provider.dart';
import 'package:takvim/providers/mosque_provider.dart';
import 'package:takvim/widgets/home_page/app_bar_content.dart';
import '../common/styling.dart';
import '../widgets/home_page/home_page_widgets.dart';
import '../providers/date_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double baseSize = size.height;

    double ratio = 375 / 667;
    final double colWidth = baseSize * ratio;

    return Consumer(
      builder: (context, watch, child) {
        final LanguagePack _appLang = watch(appLanguagePackProvider.state);
        final String _selectedMosque = watch(selectedMosque.state);
        final LanguagePackController _langPackController = watch(
          languagePackController,
        );
        if (_appLang == null) {
          _langPackController.updateAppLanguage();
        }

        final SelectedDate _selectedDate = watch(selectedDate);

        final MosqueController _mosqueController = watch(
          mosqueController,
        );

        return Container(
          color: Theme.of(context).primaryColor,
          child: SafeArea(
            bottom: false,
            child: Scaffold(
              appBar: CustomAppBar(
                height: 70,
                child: HomePageAppBarContent(
                  mosqueController: _mosqueController,
                  selectedMosque: _selectedMosque,
                ),
              ),
              drawer: _DrawerHomePage(
                languagePack: _appLang,
              ),
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Center(
                  child: FutureBuilder(
                    future: _langPackController.getAppLangPack(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: colWidth),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Consumer(
                                builder: (context, watch, child) {
                                  watch(selectedDate.state);
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CalendarDayPicker(
                                          selectedDate: _selectedDate),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      DateSelectorRow(
                                          selectedDate: _selectedDate,
                                          appLang: _appLang),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      DailyDataView(
                                        mosqueController: _mosqueController,
                                        selectedDate: _selectedDate,
                                        appLang: _appLang,
                                      ),
                                    ],
                                  );
                                },
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
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DrawerHomePage extends StatelessWidget {
  const _DrawerHomePage({
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
