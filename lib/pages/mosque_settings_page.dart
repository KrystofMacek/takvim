import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/data/models/mosque_data.dart';
import 'package:takvim/providers/language_provider.dart';
import 'package:takvim/providers/mosque_provider.dart';

class MosqueSettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);
    final LanguagePack _prayerLang = watch(prayerLanguagePackProvider.state);
    final LanguagePackController _langPackController = watch(
      languagePackController,
    );
    if (_appLang == null) {
      _langPackController.updateAppLanguage();
    }
    if (_prayerLang == null) {
      _langPackController.updatePrayerLanguage();
    }

    SelectedMosque _selectedMosque = watch(selectedMosque);
    final MosqueController _mosqueController = watch(
      mosqueController,
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        onPressed: () {
          final prefBox = Hive.box('pref');

          String appLang = prefBox.get('appLang');
          String prayerLang = prefBox.get('prayerLang');
          String mosque = prefBox.get('mosque');

          print('BOX mosq: $appLang $prayerLang $mosque');
          Navigator.pushNamed(context, '/home');
        },
      ),
      body: Center(
        child: FutureBuilder<bool>(
          future: _langPackController.getPacks(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text('${_appLang.mosque}'),
                  Consumer(
                    builder: (context, watch, child) {
                      String _selectedMosque = watch(selectedMosque.state);

                      return FutureBuilder<MosqueData>(
                        future: _mosqueController
                            .getSelectedMosque(_selectedMosque),
                        builder: (BuildContext context,
                            AsyncSnapshot<MosqueData> snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${snapshot.data.name}'),
                                Text(
                                    '${snapshot.data.ort} ${snapshot.data.kanton}'),
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // TextField(
                  //   decoration: InputDecoration(
                  //       contentPadding: EdgeInsets.all(10),
                  //       hintText: '${_appLang.mosque}...'),
                  //   onChanged: (value) {},
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Expanded(
                    child: FutureBuilder<List<MosqueData>>(
                      future: _mosqueController.getListOfMosques(),
                      initialData: [],
                      builder: (BuildContext context,
                          AsyncSnapshot<List<MosqueData>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.separated(
                            itemCount: snapshot.data.length,
                            separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                            itemBuilder: (context, index) {
                              MosqueData data = snapshot.data[index];

                              return GestureDetector(
                                onTap: () {
                                  _selectedMosque
                                      .updateSelectedMosque(data.mosqueId);
                                },
                                child: Card(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('${data.name}'),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text('${data.ort} ${data.kanton}'),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
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
    );
  }
}
