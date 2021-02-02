import 'dart:io';

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
        bottom: false,
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
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              '${data.offiziellerName}',
              style: Theme.of(context).textTheme.headline3,
              group: autoSizeGroup,
              wrapWords: false,
              maxLines: 1,
            ),
          ],
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    '${data.strasse}',
                    group: autoSizeGroup,
                    style: Theme.of(context).textTheme.headline3,
                    minFontSize: 0,
                    maxLines: 1,
                  ),
                  AutoSizeText(
                    '${data.plz} ${data.ort} ${data.kanton}',
                    group: autoSizeGroup,
                    minFontSize: 0,
                    style: Theme.of(context).textTheme.headline3,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () async {
                  String road =
                      data.strasse.replaceAll(RegExp(r"\s+\b|\b\s"), "+");
                  String url =
                      'https://www.google.com/maps/search/?api=1&query=${data.strasse}+${data.plz}+${data.ort}+${data.kanton}';
                  if (Platform.isIOS) {
                    url =
                        'http://maps.apple.com/?address=${data.ort}+${data.kanton}+$road';
                  }
                  try {
                    await launch(url);
                  } catch (e) {
                    print(e);
                  }
                },
                child: Material(
                  borderRadius: BorderRadius.circular(50),
                  elevation: 1,
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: FaIcon(
                      FontAwesomeIcons.mapMarked,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 6,
              child: AutoSizeText(
                '${data.telefon}',
                group: autoSizeGroup,
                style: Theme.of(context).textTheme.headline3,
                maxLines: 1,
                minFontSize: 0,
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () async {
                  String url = 'tel:${data.telefon}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Material(
                  borderRadius: BorderRadius.circular(50),
                  elevation: 1,
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: FaIcon(
                      FontAwesomeIcons.phone,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 35,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 6,
              child: AutoSizeText(
                '${data.website}',
                group: autoSizeGroup,
                style: Theme.of(context).textTheme.headline3,
                wrapWords: false,
                minFontSize: 0,
                maxLines: 1,
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () async {
                  String url = 'http://${data.website}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Material(
                  borderRadius: BorderRadius.circular(50),
                  elevation: 1,
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: FaIcon(
                      FontAwesomeIcons.link,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 35,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 6,
              child: AutoSizeText(
                '${data.email}',
                group: autoSizeGroup,
                style: Theme.of(context).textTheme.headline3,
                minFontSize: 0,
                maxLines: 1,
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () async {
                  String url = 'mailto:${data.email}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Material(
                  borderRadius: BorderRadius.circular(50),
                  elevation: 1,
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: FaIcon(
                      FontAwesomeIcons.envelope,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 25,
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
