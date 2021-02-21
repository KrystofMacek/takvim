import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/data/models/mosque_data.dart';
import 'package:takvim/providers/language_page/language_provider.dart';
import 'package:takvim/providers/mosque_page/mosque_provider.dart';
import 'package:takvim/widgets/home_page/app_bar.dart';
import 'package:takvim/widgets/mosque_page/app_bar_content.dart';
import '../widgets/mosque_page/mosque_page_widgets.dart';
import '../providers/home_page/date_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/mosque_page/drawer.dart';

class MosqueSettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);
    final LanguagePackController _langPackController = watch(
      languagePackController,
    );
    if (_appLang == null) {
      _langPackController.updateAppLanguage();
    }

    SelectedMosque _selectedMosque = watch(selectedMosque);
    // String _selectedMosqueId = watch(selectedMosque.state);
    final MosqueController _mosqueController = watch(
      mosqueController,
    );
    final SelectedDate _selectedDateController = watch(
      selectedDate,
    );
    final size = MediaQuery.of(context).size;
    double baseSize = size.height;

    double ratio = 375 / 667;
    final double colWidth = baseSize * ratio;

    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(
            height: 70,
            child: MosqueSettingsAppBarContent(appLang: _appLang),
          ),
          drawer: MosqueSettingPageDrawer(
            languagePack: _appLang,
          ),
          floatingActionButton: Material(
            borderRadius: BorderRadius.circular(50),
            elevation: 2,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.check,
                  size: 28,
                ),
                onPressed: () {
                  final prefBox = Hive.box('pref');

                  if (_selectedMosque.getSelectedMosqueId() == null) {
                    String prefSelect = prefBox.get('mosque');
                    if (prefSelect == null) {
                      _selectedMosque.updateSelectedMosque('1001');
                    } else {
                      _selectedMosque.updateSelectedMosque(prefSelect);
                    }
                  }

                  prefBox.put('mosque', _selectedMosque.getSelectedMosqueId());

                  FirebaseDatabase.instance
                      .reference()
                      .child('prayerTimes')
                      .child(_selectedMosque.getSelectedMosqueId())
                      .keepSynced(true);

                  if (prefBox.get('firstOpen')) {
                    prefBox.put('firstOpen', false);
                    Navigator.pushNamed(context, '/home');
                  } else {
                    _selectedDateController.updateSelectedDate(DateTime.now());
                    Navigator.popUntil(context, ModalRoute.withName('/home'));
                  }
                },
              ),
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: colWidth),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Consumer(
                            builder: (context, watch, child) {
                              String selectedMosqueId =
                                  watch(selectedMosque.state);
                              return SelectedMosqueView(
                                mosqueController: _mosqueController,
                                selectedMosqueController: selectedMosqueId,
                              );
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FilterMosqueInput(
                            appLang: _appLang,
                            mosqueController: _mosqueController,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          StreamBuilder<List<MosqueData>>(
                            stream: _mosqueController
                                .watchPrayerTimeFirestoreMosques(),
                            initialData: [],
                            builder: (BuildContext context,
                                AsyncSnapshot<List<MosqueData>> snapshot) {
                              if (snapshot.hasData) {
                                return Consumer(
                                  builder: (context, watch, child) {
                                    List<MosqueData> filteredList =
                                        watch(filteredMosqueList.state);
                                    String selectedId =
                                        watch(selectedMosque.state);

                                    return Expanded(
                                      child: ListView.separated(
                                        itemCount: filteredList.length + 1,
                                        separatorBuilder: (context, index) =>
                                            SizedBox(),
                                        itemBuilder: (context, index) {
                                          if (index == filteredList.length) {
                                            return SizedBox(
                                              height: 80,
                                            );
                                          }
                                          MosqueData data = filteredList[index];

                                          bool isSelected =
                                              (data.mosqueId == selectedId);

                                          return MosqueItem(
                                            data: data,
                                            isSelected: isSelected,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
