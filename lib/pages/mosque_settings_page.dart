import 'package:MyMosq/providers/home_page/pager.dart';
import 'package:MyMosq/widgets/mosque_page/body.dart';
import 'package:MyMosq/widgets/mosque_page/fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import 'package:MyMosq/data/models/mosque_data.dart';
import 'package:MyMosq/providers/common/device_snapshot_provider.dart';
import 'package:MyMosq/providers/language_page/language_provider.dart';
import 'package:MyMosq/providers/mosque_page/mosque_provider.dart';
import 'package:MyMosq/providers/subscription/subs_list_provider.dart';
import 'package:MyMosq/widgets/home_page/app_bar.dart';
import 'package:MyMosq/widgets/mosque_page/app_bar_content.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
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
    MosqueController filteringController = watch(mosqueController);
    if (_appLang == null) {
      _langPackController.updateAppLanguage();
    }

    TempSelectedMosque _tempSelectedMosque = watch(tempSelectedMosque);
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

    final Connectivity _connectivity = Connectivity();

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
          floatingActionButton: MosqueSettingsPageFab(
            tempSelectedMosque: _tempSelectedMosque,
            selectedDateController: _selectedDateController,
            filteringController: filteringController,
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
                      child: MosqueSettingsPageContent(
                        mosqueController: _mosqueController,
                        appLang: _appLang,
                        connectivity: _connectivity,
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
