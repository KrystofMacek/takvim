import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:takvim/common/constants.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/firestore_provider.dart';
import 'package:takvim/providers/language_page/language_provider.dart';

final versionCheckProvider = StateNotifierProvider<VersionCheck>((ref) =>
    VersionCheck(ref.watch(firestoreProvider),
        ref.watch(appLanguagePackProvider.state)));

class VersionCheck extends StateNotifier<bool> {
  VersionCheck(FirebaseFirestore firestore, LanguagePack langPack)
      : _appLanguage = langPack,
        _firestore = firestore,
        super(true);

  FirebaseFirestore _firestore;
  LanguagePack _appLanguage;

  void showUpdateAlert(BuildContext context) async {
    DocumentSnapshot doc =
        await _firestore.collection('settings').doc('appVersion').get();

    String _version = doc.get('latest');

    if (_version != CURRENT_VERSION && state) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('${_appLanguage.updateMessage}'),
            actions: <Widget>[
              TextButton(
                child: Text('${_appLanguage.cancel}'),
                onPressed: () {
                  Navigator.of(context).pop();
                  state = false;
                },
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextButton(
                  child: Text(
                    '${_appLanguage.update}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    StoreRedirect.redirect();
                    state = false;
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
