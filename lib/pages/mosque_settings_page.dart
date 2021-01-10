import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/data/models/mosque_data.dart';
import 'package:takvim/providers/language_provider.dart';
import 'package:takvim/providers/mosque_provider.dart';
import '../common/styling.dart';
import '../widgets/mosque_page/mosque_page_widgets.dart';
import '../providers/date_provider.dart';
import 'package:firebase_database/firebase_database.dart';

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.mainColor,
        automaticallyImplyLeading: false,
        title: Center(
            child: Text(
          '${_appLang.selectMosque}',
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
            Navigator.pop(context);
          }
        },
      ),
      body: Flex(
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
                      String selectedMosqueId = watch(selectedMosque.state);
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
                      appLang: _appLang, mosqueController: _mosqueController),
                  SizedBox(
                    height: 5,
                  ),
                  StreamBuilder<List<MosqueData>>(
                    stream: _mosqueController.watchMosques(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<MosqueData>> snapshot) {
                      print('has data${snapshot.hasData}');
                      if (snapshot.hasData) {
                        return Consumer(
                          builder: (context, watch, child) {
                            List<MosqueData> filteredList =
                                watch(filteredMosqueList.state);
                            String selectedId = watch(selectedMosque.state);

                            return Expanded(
                              child: ListView.separated(
                                itemCount: filteredList.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(),
                                itemBuilder: (context, index) {
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
    );
  }
}

// FutureBuilder(
//                     future: _mosqueController.getListOfMosques(),
//                     initialData: [],
//                     builder: (BuildContext context, AsyncSnapshot snapshot) {
//                       if (snapshot.hasData) {
//                         return Consumer(
//                           builder: (context, watch, child) {
//                             watch(selectedMosque.state);

//                             List<MosqueData> filteredList =
//                                 watch(filteredMosqueList.state);
//                             return Expanded(
//                               child: ListView.separated(
//                                 itemCount: filteredList.length,
//                                 separatorBuilder: (context, index) =>
//                                     SizedBox(),
//                                 itemBuilder: (context, index) {
//                                   MosqueData data = filteredList[index];

//                                   bool isSelected = (data.mosqueId ==
//                                       _selectedMosque.getSelectedMosqueId());

//                                   return MosqueItem(
//                                     data: data,
//                                     isSelected: isSelected,
//                                   );
//                                 },
//                               ),
//                             );
//                           },
//                         );
//                       } else {
//                         return CircularProgressIndicator();
//                       }
//                     },
//                   ),
