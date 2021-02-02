import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/language_pack.dart';

class LanguageAppBarContent extends StatelessWidget {
  const LanguageAppBarContent({
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
                '${_appLang.selectLanguage}',
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
            children: [
              // MaterialButton(
              //   onPressed: () {
              //     final prefBox = Hive.box('pref');

              //     prefBox.put('appLang', _appLang.languageId);

              //     bool firstOpen = prefBox.get('firstOpen');
              //     if (firstOpen) {
              //       Navigator.pushNamed(context, '/mosque');
              //     } else {
              //       Navigator.popUntil(context, ModalRoute.withName('/home'));
              //     }
              //   },
              //   elevation: 1,
              //   color: Theme.of(context).primaryColor,
              //   splashColor: Theme.of(context).primaryColor,
              //   textColor: Theme.of(context).iconTheme.color,
              //   child: FaIcon(
              //     FontAwesomeIcons.check,
              //     size: 24,
              //   ),
              //   padding: EdgeInsets.all(12),
              //   shape: CircleBorder(),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
