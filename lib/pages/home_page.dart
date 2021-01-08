import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/date_provider.dart';
import 'package:takvim/providers/language_provider.dart';
import 'package:takvim/providers/mosque_provider.dart';
import '../common/styling.dart';
import '../widgets/home_page/home_page_widgets.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);
    // final LanguagePack _prayerLang = watch(prayerLanguagePackProvider.state);
    final String _selectedMosque = watch(selectedMosque.state);
    final LanguagePackController _langPackController = watch(
      languagePackController,
    );
    if (_appLang == null) {
      _langPackController.updateAppLanguage();
    }
    // if (_prayerLang == null) {
    //   _langPackController.updatePrayerLanguage();
    // }

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
            future: _langPackController.getPacks(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Consumer(
                      builder: (context, watch, child) {
                        watch(selectedDate.state);

                        return Expanded(
                          child: Column(
                            children: [
                              CalendarDayPicker(selectedDate: _selectedDate),
                              DateSelectorRow(
                                  selectedDate: _selectedDate,
                                  appLang: _appLang),
                              IconButton(
                                icon: Icon(
                                  Icons.refresh,
                                  size: 35,
                                ),
                                color: CustomColors.mainColor,
                                onPressed: () async {
                                  _selectedDate
                                      .updateSelectedDate(DateTime.now());
                                },
                              ),
                              DailyDataView(
                                  mosqueController: _mosqueController,
                                  selectedDate: _selectedDate,
                                  appLang: _appLang),
                            ],
                          ),
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
  }
}
