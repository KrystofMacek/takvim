import 'package:flutter/material.dart';
import '../../providers/language_provider.dart';
import '../../common/constants.dart';
import '../../common/styling.dart';
import 'package:hive/hive.dart';
import 'package:flag/flag.dart';

class LanguageItem extends StatelessWidget {
  const LanguageItem({
    Key key,
    @required LanguagePackController langPackController,
    @required this.flag,
    @required this.index,
    @required this.isSelected,
  })  : _langPackController = langPackController,
        super(key: key);

  final LanguagePackController _langPackController;
  final String flag;
  final int index;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return GestureDetector(
        onTap: () {
          String code = LANG_MAP[LANGUAGES[index]];
          Hive.box('pref').put('appLang', code);
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
                      '${LANGUAGES[index]}',
                      style: CustomTextFonts.contentText,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          String code = LANG_MAP[LANGUAGES[index]];
          Hive.box('pref').put('appLang', code);
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
                      '${LANGUAGES[index]}',
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
