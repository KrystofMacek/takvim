import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:MyMosq/common/utils.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import '../../providers/news_page/selected_mosque_news_provider.dart';
import '../../common/styling.dart';
import '../../providers/mosque_page/mosque_provider.dart';
import '../../common/constants.dart';

class MosqueSettingPageDrawer extends ConsumerWidget {
  const MosqueSettingPageDrawer({
    Key key,
    LanguagePack languagePack,
  })  : _languagePack = languagePack,
        super(key: key);

  final LanguagePack _languagePack;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    MosqueController filteringController = watch(mosqueController);
    return StreamBuilder<bool>(
        stream: Connectivity().isConnected,
        initialData: false,
        builder: (context, snapshot) {
          return Drawer(
            child: Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: FaIcon(
                          FontAwesomeIcons.bars,
                          size: 24,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        leading: FaIcon(
                          FontAwesomeIcons.mosque,
                          size: 22,
                        ),
                        title: Text('${_languagePack.mosque}'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        leading: FaIcon(
                          FontAwesomeIcons.globe,
                          size: 28,
                        ),
                        title: Text('${_languagePack.language}'),
                        onTap: () {
                          filteringController.resetFilter();
                          Navigator.popAndPushNamed(context, '/lang');
                        },
                      ),
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        leading: FaIcon(
                          FontAwesomeIcons.bell,
                          size: 28,
                        ),
                        title: Text('${_languagePack.prayerTimeNotification}'),
                        onTap: () {
                          // filteringController.resetFilter();
                          Navigator.popAndPushNamed(
                            context,
                            '/notificationConfig',
                          );
                        },
                      ),
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        leading: FaIcon(
                          FontAwesomeIcons.checkSquare,
                          size: 28,
                        ),
                        title: Text(
                          '${_languagePack.subscribe}',
                          style: !snapshot.data
                              ? TextStyle(color: Colors.grey)
                              : TextStyle(),
                        ),
                        onTap: () {
                          if (snapshot.data) {
                            filteringController.resetFilter();
                            Navigator.popAndPushNamed(context, '/sub');
                          }
                        },
                      ),
                      Consumer(builder: (context, watch, child) {
                        SelectedMosuqeNewsProvider prov =
                            watch(selectedMosuqeNewsProvider);
                        return ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          leading: FaIcon(
                            FontAwesomeIcons.newspaper,
                            size: 28,
                          ),
                          title: Text(
                            '${_languagePack.news}',
                            style: !snapshot.data
                                ? TextStyle(color: Colors.grey)
                                : TextStyle(),
                          ),
                          onTap: () {
                            if (snapshot.data) {
                              String target = newsNavigator(prov);
                              filteringController.resetFilter();
                              Navigator.popAndPushNamed(context, target);
                            }
                          },
                        );
                      }),
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        leading: FaIcon(
                          FontAwesomeIcons.compass,
                          size: 28,
                        ),
                        title: Text('${_languagePack.compass}'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/compass');
                        },
                      ),
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        leading: Icon(
                          Icons.wb_sunny,
                          size: 28,
                        ),
                        title: Text('${_languagePack.appTheme}'),
                        onTap: () {
                          currentTheme.switchTheme(Hive.box('pref'));
                          // Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        leading: FaIcon(
                          FontAwesomeIcons.envelope,
                          size: 28,
                        ),
                        title: Text(
                          '${_languagePack.contactUs}',
                          style: !snapshot.data
                              ? TextStyle(color: Colors.grey)
                              : TextStyle(),
                        ),
                        onTap: () {
                          if (snapshot.data) {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/contact');
                          }
                        },
                      ),
                      !snapshot.data
                          ? ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              leading: Icon(
                                Icons.wifi_off,
                                color: Colors.red[300],
                                size: 28,
                              ),
                              title: Text(
                                '${_languagePack.noInternet}',
                                style: TextStyle(color: Colors.red[300]),
                              ),
                              onTap: () {},
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, bottom: 10),
                      child: Text('v $CURRENT_VERSION',
                          style: Theme.of(context).textTheme.subtitle1),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
