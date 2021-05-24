import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:MyMosq/data/models/day_data.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import 'package:MyMosq/providers/common/notification_provider.dart';
import 'package:MyMosq/providers/language_page/language_provider.dart';
import 'package:MyMosq/widgets/home_page/app_bar.dart';
import 'package:MyMosq/widgets/language_page/app_bar_content.dart';
import 'package:MyMosq/widgets/notification_config_page/app_bar_content.dart';
import 'package:MyMosq/widgets/notification_config_page/config_times_view.dart';
import 'package:MyMosq/widgets/notification_config_page/drawer.dart';

class NotificationConfigPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);
    final LanguagePackController _langPackController =
        watch(languagePackController);

    if (_appLang == null) {
      _langPackController.updateAppLanguage();
    }
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(
            height: 70,
            child: NotificationConfigAppBarContent(appLang: _appLang),
          ),
          drawer: DrawerNotificationConfigPage(
            languagePack: _appLang,
          ),
          floatingActionButton: FloatingActionButton(
            child: FaIcon(
              FontAwesomeIcons.check,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
              Map<String, DayData> map =
                  context.read(daysToScheduleProvider.state);
              context
                  .read(notificationController)
                  .scheduleNotification(map['today'], map['tomorrow']);
            },
          ),
          body: Container(
            padding: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Center(
              child: ConfigTimesView(),
            ),
          ),
        ),
      ),
    );
  }
}
