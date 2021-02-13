import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/language_pack.dart';
import '../../data/models/mosque_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takvim/providers/mosque_page/mosque_provider.dart';
import 'package:firebase_database/firebase_database.dart';

class NewsMosquesAppBarContent extends StatelessWidget {
  const NewsMosquesAppBarContent({
    Key key,
    @required LanguagePack appLang,
  })  : _appLang = appLang,
        super(key: key);

  final LanguagePack _appLang;

  @override
  Widget build(BuildContext context) {
    final prefBox = Hive.box('pref');
    final bool firstOpen = prefBox.get('firstOpen');
    return Row(
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
                !firstOpen
                    ? IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.bars,
                          size: 24,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_appLang.news}',
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        ),
      ],
    );
  }
}

class NewsAppBarContent extends StatelessWidget {
  const NewsAppBarContent({
    Key key,
    @required String mosqueId,
  })  : _mosqueId = mosqueId,
        super(key: key);

  final String _mosqueId;

  @override
  Widget build(BuildContext context) {
    final prefBox = Hive.box('pref');
    final bool firstOpen = prefBox.get('firstOpen');
    return Row(
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
                !firstOpen
                    ? IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.bars,
                          size: 24,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
        Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Consumer(
              builder: (context, watch, child) {
                MosqueController _mosqueController = watch(mosqueController);
                return StreamBuilder<Event>(
                  stream: _mosqueController.watchMosque(_mosqueId),
                  builder:
                      (BuildContext context, AsyncSnapshot<Event> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data.snapshot.value != null) {
                      MosqueData selectedMosqueData =
                          MosqueData.fromFirebase(snapshot.data.snapshot.value);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${selectedMosqueData.ort} ${selectedMosqueData.kanton}',
                            style: Theme.of(context).textTheme.headline1,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${selectedMosqueData.name}',
                            style: Theme.of(context).textTheme.headline2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              },
            )),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        ),
      ],
    );
  }
}
