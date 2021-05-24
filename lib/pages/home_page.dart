import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:MyMosq/common/constants.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import 'package:MyMosq/providers/common/device_snapshot_provider.dart';
import 'package:MyMosq/providers/common/version_check_provider.dart';
import 'package:MyMosq/providers/firestore_provider.dart';
import 'package:MyMosq/providers/home_page/date_provider.dart';
import 'package:MyMosq/providers/language_page/language_provider.dart';
import 'package:MyMosq/providers/mosque_page/mosque_provider.dart';
import 'package:MyMosq/widgets/home_page/app_bar_content.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // context.read(versionCheckProvider).showUpdateAlert(context);

      if (context.read(versionCheckProvider.state)) {
        context.read(versionCheckProvider).update(false);
        DocumentSnapshot doc = await context
            .read(firestoreProvider)
            .collection('settings')
            .doc('appVersion')
            .get();

        LanguagePack lang = context.read(appLanguagePackProvider.state);

        String _version = doc.get('latest');
        if (_version != CURRENT_VERSION) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('${lang.updateMessage}'),
                actions: <Widget>[
                  TextButton(
                    child: Text('${lang.cancel}'),
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/home'));
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextButton(
                      child: Text(
                        '${lang.update}',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        StoreRedirect.redirect(iOSAppId: "1548479130");
                        Navigator.popUntil(
                            context, ModalRoute.withName('/home'));
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }
      }
    });

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

        final MosqueController _mosqueController = watch(mosqueController);

        context.read(deviceSnapshotProvider).updateSnapshot(false);

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
                padding:
                    EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 15),
                child: Center(
                  child: FutureBuilder(
                    future: _langPackController.getAppLangPack(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: colWidth),
                            child: Flex(
                              direction: Axis.vertical,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Consumer(
                                        builder: (context, watch, child) {
                                          watch(selectedDate.state);
                                          return Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  CalendarDayPicker(
                                                      selectedDate:
                                                          _selectedDate),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  DateSelectorRow(
                                                      selectedDate:
                                                          _selectedDate,
                                                      appLang: _appLang),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: DailyDataView(
                                                        mosqueController:
                                                            _mosqueController,
                                                        selectedDate:
                                                            _selectedDate,
                                                        appLang: _appLang,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ));
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
