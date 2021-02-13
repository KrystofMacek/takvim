import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/models/language_pack.dart';
import '../../common/styling.dart';
import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/firestore_provider.dart';
import 'package:cross_connectivity/cross_connectivity.dart';

class NewsMosquesDrawer extends ConsumerWidget {
  const NewsMosquesDrawer({
    Key key,
    LanguagePack languagePack,
  })  : _languagePack = languagePack,
        super(key: key);

  final LanguagePack _languagePack;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    SubsFilteringController filteringController =
        watch(subsFilteringController);
    return StreamBuilder<bool>(
        stream: Connectivity().isConnected,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data) {
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
                          title: Text('${_languagePack.selectMosque}'),
                          onTap: () {
                            filteringController.resetFilter();
                            Navigator.popAndPushNamed(context, '/mosque');
                          },
                        ),
                        ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          leading: FaIcon(
                            FontAwesomeIcons.globe,
                            size: 28,
                          ),
                          title: Text('${_languagePack.selectLanguage}'),
                          onTap: () {
                            filteringController.resetFilter();
                            Navigator.popAndPushNamed(context, '/lang');
                          },
                        ),
                        Consumer(builder: (context, watch, child) {
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            leading: FaIcon(
                              FontAwesomeIcons.newspaper,
                              size: 28,
                            ),
                            title: Text('${_languagePack.news}'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          );
                        }),
                        ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          leading: FaIcon(
                            FontAwesomeIcons.bell,
                            size: 28,
                          ),
                          title: Text('${_languagePack.subscribe}'),
                          onTap: () {
                            Navigator.popAndPushNamed(context, '/sub');
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
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
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
                            FontAwesomeIcons.globe,
                            size: 28,
                          ),
                          title: Text('${_languagePack.selectLanguage}'),
                          onTap: () {
                            filteringController.resetFilter();
                            Navigator.popAndPushNamed(context, '/lang');
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
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}