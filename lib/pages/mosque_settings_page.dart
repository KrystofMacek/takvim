import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/data/models/mosque_data.dart';
import 'package:takvim/providers/language_provider.dart';
import 'package:takvim/providers/mosque_provider.dart';
import '../common/styling.dart';
import '../widgets/mosque_page/mosque_page_widgets.dart';

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
    final MosqueController _mosqueController = watch(
      mosqueController,
    );
    _mosqueController.getListOfMosques();

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
          if (prefBox.get('firstOpen')) {
            prefBox.put('firstOpen', false);
          }
          Navigator.pushNamed(context, '/home');
        },
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          FutureBuilder<bool>(
            future: _langPackController.getPacks(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        SelectedMosqueView(mosqueController: _mosqueController),
                        SizedBox(
                          height: 10,
                        ),
                        FilterMosqueInput(
                            appLang: _appLang,
                            mosqueController: _mosqueController),
                        SizedBox(
                          height: 5,
                        ),
                        Consumer(
                          builder: (context, watch, child) {
                            List<MosqueData> filteredList =
                                watch(filteredMosqueList.state);
                            return Expanded(
                              child: ListView.separated(
                                itemCount: filteredList.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(),
                                itemBuilder: (context, index) {
                                  MosqueData data = filteredList[index];

                                  return MosqueItem(data: data);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
