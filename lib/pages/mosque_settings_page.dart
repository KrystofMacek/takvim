import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/data/models/mosque_data.dart';
import 'package:takvim/providers/language_provider.dart';
import 'package:takvim/providers/mosque_provider.dart';
import '../common/styling.dart';

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
        automaticallyImplyLeading: false,
        title: Center(child: Text('${_appLang.select} ${_appLang.mosque}')),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      SelectedMosqueView(mosqueController: _mosqueController),
                      FilterMosqueInput(
                          appLang: _appLang,
                          mosqueController: _mosqueController),
                      SizedBox(
                        height: 10,
                      ),
                      Consumer(
                        builder: (context, watch, child) {
                          List<MosqueData> filteredList =
                              watch(filteredMosqueList.state);
                          return Expanded(
                            child: ListView.separated(
                              itemCount: filteredList.length,
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
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

class MosqueItem extends ConsumerWidget {
  const MosqueItem({
    Key key,
    @required this.data,
  }) : super(key: key);

  final MosqueData data;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    String _selectedMosqueState = watch(selectedMosque.state);
    SelectedMosque _mosqueSelector = watch(selectedMosque);
    if (_selectedMosqueState == data.mosqueId) {
      return GestureDetector(
        onTap: () {
          _mosqueSelector.updateSelectedMosque(data.mosqueId);
        },
        child: Card(
          color: Colors.blue[100],
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data.name}',
                  style: CustomTextFonts.mosqueListName,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${data.ort} ${data.kanton}',
                  style: CustomTextFonts.mosqueListOther,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          _mosqueSelector.updateSelectedMosque(data.mosqueId);
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data.name}',
                  style: CustomTextFonts.mosqueListName,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${data.ort} ${data.kanton}',
                  style: CustomTextFonts.mosqueListOther,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class FilterMosqueInput extends StatelessWidget {
  const FilterMosqueInput({
    Key key,
    @required LanguagePack appLang,
    @required MosqueController mosqueController,
  })  : _appLang = appLang,
        _mosqueController = mosqueController,
        super(key: key);

  final LanguagePack _appLang;
  final MosqueController _mosqueController;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        watch(mosqueList);
        return TextField(
          style: CustomTextFonts.mosqueListOther,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              hintText: '${_appLang.mosque} / ${_appLang.ort}...'),
          onChanged: (value) {
            _mosqueController.filterMosqueList(value);
          },
        );
      },
    );
  }
}

class SelectedMosqueView extends StatelessWidget {
  const SelectedMosqueView({
    Key key,
    @required MosqueController mosqueController,
  })  : _mosqueController = mosqueController,
        super(key: key);

  final MosqueController _mosqueController;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        String _selectedMosque = watch(selectedMosque.state);

        return FutureBuilder<MosqueData>(
          future: _mosqueController.getSelectedMosque(_selectedMosque),
          builder: (BuildContext context, AsyncSnapshot<MosqueData> snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${snapshot.data.name}',
                    style: CustomTextFonts.mosqueListName,
                  ),
                  Text(
                    '${snapshot.data.ort} ${snapshot.data.kanton}',
                    style: CustomTextFonts.mosqueListOther,
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}
