import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/date_provider.dart';
import 'package:takvim/providers/language_provider.dart';
import 'package:takvim/providers/mosque_provider.dart';
import '../common/styling.dart';
import '../widgets/home_page/home_page_widgets.dart';
import '../providers/date_provider.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        // _langPackController.updateAppLanguage();

        final SelectedDate _selectedDate = watch(selectedDate);

        final MosqueController _mosqueController = watch(
          mosqueController,
        );

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: AppBar(
              backgroundColor: CustomColors.mainColor,
              automaticallyImplyLeading: false,
              centerTitle: true,
              flexibleSpace: Center(
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width * .6,
                  child: SelectedMosqueView(
                      mosqueController: _mosqueController,
                      selectedMosque: _selectedMosque),
                ),
              ),
              actions: [
                SettingBtnView(appLang: _appLang),
              ],
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Center(
              child: FutureBuilder(
                future: _langPackController.getAppLangPack(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Consumer(
                          builder: (context, watch, child) {
                            watch(selectedDate.state);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CalendarDayPicker(selectedDate: _selectedDate),
                                SizedBox(
                                  height: 10,
                                ),
                                DateSelectorRow(
                                    selectedDate: _selectedDate,
                                    appLang: _appLang),
                                SizedBox(
                                  height: 20,
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
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
