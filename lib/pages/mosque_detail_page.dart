import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/data/models/mosque_data.dart';
import 'package:takvim/providers/mosque_detail_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/home_page/app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import '../common/styling.dart';
import '../providers/language_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MosqueDetailPage extends ConsumerWidget {
  MosqueDetailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final MosqueData data = watch(selectedMosqueDetail.state);
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);

    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            height: 70,
            child: DetailsAppBarContent(data: data),
          ),
          drawer: _DrawerDetailsPage(
            languagePack: _appLang,
          ),
          floatingActionButton: FloatingActionButton(
            child: FaIcon(
              FontAwesomeIcons.times,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Center(
            child: Container(
              padding: EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DetailsContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailsContent extends ConsumerWidget {
  const DetailsContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final MosqueData data = watch(selectedMosqueDetail.state);
    var autoSizeGroup = AutoSizeGroup();
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.mosque,
                      color: Theme.of(context).colorScheme.secondaryVariant,
                      size: 18,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () async {},
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * .65),
                        child: AutoSizeText(
                          '${data.offiziellerName}',
                          style: Theme.of(context).textTheme.headline3,
                          group: autoSizeGroup,
                          wrapWords: false,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    String url =
                        'https://www.google.com/maps/search/?api=1&query=${data.strasse}+${data.plz}+${data.ort}+${data.kanton}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.mapMarked,
                        color: Theme.of(context).colorScheme.secondaryVariant,
                        size: 18,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * .65),
                            child: AutoSizeText(
                              '${data.strasse}',
                              group: autoSizeGroup,
                              style: Theme.of(context).textTheme.headline3,
                              maxLines: 1,
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * .65),
                            child: AutoSizeText(
                              '${data.plz} ${data.ort} ${data.kanton}',
                              group: autoSizeGroup,
                              style: Theme.of(context).textTheme.headline3,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FaIcon(
                        FontAwesomeIcons.arrowCircleRight,
                        color: Theme.of(context).colorScheme.secondaryVariant,
                        size: 20,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    String url = 'tel:${data.telefon}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.phone,
                        color: Theme.of(context).colorScheme.secondaryVariant,
                        size: 18,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * .65),
                        child: AutoSizeText(
                          '${data.telefon}',
                          group: autoSizeGroup,
                          style: Theme.of(context).textTheme.headline3,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FaIcon(
                        FontAwesomeIcons.arrowCircleRight,
                        color: Theme.of(context).colorScheme.secondaryVariant,
                        size: 20,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    String url = 'http://${data.website}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.link,
                        color: Theme.of(context).colorScheme.secondaryVariant,
                        size: 18,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * .65),
                        child: AutoSizeText(
                          '${data.website}',
                          group: autoSizeGroup,
                          style: Theme.of(context).textTheme.headline3,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FaIcon(
                        FontAwesomeIcons.arrowCircleRight,
                        color: Theme.of(context).colorScheme.secondaryVariant,
                        size: 20,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    String url = 'mailto:${data.email}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.envelope,
                        color: Theme.of(context).colorScheme.secondaryVariant,
                        size: 18,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * .65),
                        child: AutoSizeText(
                          '${data.email}',
                          group: autoSizeGroup,
                          style: Theme.of(context).textTheme.headline3,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FaIcon(
                        FontAwesomeIcons.arrowCircleRight,
                        color: Theme.of(context).colorScheme.secondaryVariant,
                        size: 20,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class DetailsAppBarContent extends StatelessWidget {
  const DetailsAppBarContent({
    Key key,
    @required this.data,
  }) : super(key: key);

  final MosqueData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.bars,
                    size: 24,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                )
              ],
            ),
          ),
        ),
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${data.ort} ${data.kanton}',
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${data.name}',
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Column(),
        ),
      ],
    );
  }
}

class _DrawerDetailsPage extends StatelessWidget {
  const _DrawerDetailsPage({
    Key key,
    LanguagePack languagePack,
  })  : _languagePack = languagePack,
        super(key: key);

  final LanguagePack _languagePack;

  @override
  Widget build(BuildContext context) {
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
}
