import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MyMosq/common/constants.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import 'package:cross_connectivity/cross_connectivity.dart';

class SettingBtnView extends StatelessWidget {
  const SettingBtnView({
    Key key,
    @required LanguagePack appLang,
  })  : _appLang = appLang,
        super(key: key);

  final LanguagePack _appLang;

  @override
  Widget build(BuildContext context) {
    Connectivity _connectivity = Connectivity();
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
      child: StreamBuilder<bool>(
        stream: _connectivity.isConnected,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data) {
            return PopupMenuButton<String>(
              onSelected: _settingsMenuItemSelected,
              icon: Icon(
                Icons.settings,
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
            );
          } else {
            return PopupMenuButton<String>(
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
                          child: Text(
                            '${_appLang.language}',
                            textAlign: TextAlign.center,
                          ),
                        );
                        break;
                      case MOSQUE_SETTINGS:
                        return PopupMenuItem(
                          enabled: false,
                          value: choice,
                          child: Text(
                            '${_appLang.mosque}',
                            textAlign: TextAlign.center,
                          ),
                        );
                        break;
                      default:
                    }
                  },
                ).toList();
              },
            );
          }
        },
      ),
    );
  }
}
