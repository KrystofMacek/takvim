import 'package:flutter/material.dart';
import '../../providers/language_provider.dart';
import '../../common/styling.dart';
import 'package:hive/hive.dart';
import 'package:flag/flag.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/language_pack.dart';

class LanguageItem extends ConsumerWidget {
  const LanguageItem({
    Key key,
    @required LanguagePackController langPackController,
    @required this.flag,
    @required this.pack,
    @required this.isSelected,
  })  : _langPackController = langPackController,
        super(key: key);

  final LanguagePackController _langPackController;
  final String flag;
  final LanguagePack pack;
  final bool isSelected;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // final langpack = watch(appLanguagePackProvider.state);
    if (isSelected) {
      return Consumer(
        builder: (context, watch, child) {
          return GestureDetector(
            onTap: () {
              Hive.box('pref').put('appLang', pack.languageId);
              _langPackController.updateAppLanguage();
            },
            child: Card(
              color: Colors.blue[100],
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Flag(
                        flag,
                        height: 30,
                        width: 40,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${pack.languageName}',
                          style: CustomTextFonts.contentText,
                        ),
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
      return GestureDetector(
        onTap: () {
          Hive.box('pref').put('appLang', pack.languageId);
          _langPackController.updateAppLanguage();
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Flag(
                    flag,
                    height: 30,
                    width: 40,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${pack.languageName}',
                      style: CustomTextFonts.contentText,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
