import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/home_page/date_provider.dart';
import 'package:takvim/providers/language_page/language_provider.dart';
import 'package:takvim/providers/mosque_page/mosque_provider.dart';
import 'package:takvim/widgets/home_page/app_bar_content.dart';
import '../widgets/home_page/home_page_widgets.dart';
import '../providers/home_page/date_provider.dart';
import '../widgets/home_page/widgets_home.dart';

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
              drawer: DrawerHomePage(
                languagePack: _appLang,
              ),
              body: Container(
                padding: EdgeInsets.only(top: 15, left: 20, right: 20),
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
