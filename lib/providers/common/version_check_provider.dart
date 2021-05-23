import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:takvim/common/constants.dart';
import 'package:takvim/providers/firestore_provider.dart';

final versionCheckProvider = StateNotifierProvider<VersionCheck>(
    (ref) => VersionCheck(ref.watch(firestoreProvider)));

class VersionCheck extends StateNotifier<bool> {
  VersionCheck(FirebaseFirestore firestore)
      : _firestore = firestore,
        super(true);

  // void update(bool showUpdateNotification) => state = showUpdateNotification;
  // bool get state;

  FirebaseFirestore _firestore;

  // Future<void> runVersionCheck() async {
  //   DocumentSnapshot doc =
  //       await _firestore.collection('settings').doc('appVersion').get();

  //   String _version = doc.get('latest');

  //   if (_version != CURRENT_VERSION) {
  //     update(true);
  //   }
  // }

  void showUpdateAlert(BuildContext context) async {
    DocumentSnapshot doc =
        await _firestore.collection('settings').doc('appVersion').get();

    String _version = doc.get('latest');

    if (_version != CURRENT_VERSION && state) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New Version Available!'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
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
                  child: const Text(
                    'Update',
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
