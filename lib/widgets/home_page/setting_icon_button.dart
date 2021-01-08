import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takvim/common/constants.dart';
import 'package:takvim/data/models/language_pack.dart';

class SettingBtnView extends StatelessWidget {
  const SettingBtnView({
    Key key,
    @required LanguagePack appLang,
  })  : _appLang = appLang,
        super(key: key);

  final LanguagePack _appLang;

  @override
  Widget build(BuildContext context) {
    void _settingsMenuItemSelected(String choice) {
      switch (choice) {
        case LANG_SETTINGS:
          Navigator.pushNamed(context, '/lang');
          break;
        case MOSQUE_SETTINGS:
          Navigator.pushNamed(context, '/mosque');
          break;
        default:
      }
    }

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: PopupMenuButton<String>(
        onSelected: _settingsMenuItemSelected,
        icon: Icon(
          Icons.settings,
          color: Colors.white,
        ),
        itemBuilder: (context) {
          return [LANG_SETTINGS, MOSQUE_SETTINGS].map(
            (String choice) {
              switch (choice) {
                case LANG_SETTINGS:
                  return PopupMenuItem(
                    value: choice,
                    child: Text('${_appLang.language}'),
                  );
                  break;
                case MOSQUE_SETTINGS:
                  return PopupMenuItem(
                    value: choice,
                    child: Text('${_appLang.mosque}'),
                  );
                  break;
                default:
              }
            },
          ).toList();
        },
      ),
    );
  }
}
