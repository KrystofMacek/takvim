import 'package:MyMosq/providers/home_page/date_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:MyMosq/providers/mosque_page/mosque_provider.dart';
import 'package:MyMosq/providers/subscription/subs_list_provider.dart';
import 'package:firebase_database/firebase_database.dart';

class MosqueSettingsPageFab extends StatelessWidget {
  const MosqueSettingsPageFab({
    Key key,
    @required TempSelectedMosque tempSelectedMosque,
    @required SelectedDate selectedDateController,
    @required this.filteringController,
  })  : _tempSelectedMosque = tempSelectedMosque,
        _selectedDateController = selectedDateController,
        super(key: key);

  final TempSelectedMosque _tempSelectedMosque;
  final SelectedDate _selectedDateController;
  final MosqueController filteringController;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(50),
      elevation: 2,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.check,
            size: 28,
          ),
          onPressed: () {
            // get user preferences
            final prefBox = Hive.box('pref');
            String mosqueId;

            // update temp selected mosque
            if (_tempSelectedMosque.getTempSelectedMosqueId() == null) {
              String prefSelect = prefBox.get('mosque');
              if (prefSelect == null) {
                _tempSelectedMosque.updateTempSelectedMosque('1001');
              } else {
                _tempSelectedMosque.updateTempSelectedMosque(prefSelect);
              }
            }

            // update global selected mosque with the temporary id used in mosque selection page
            mosqueId = _tempSelectedMosque.getTempSelectedMosqueId();
            context.read(selectedMosque).updateSelectedMosque(mosqueId);

            // save to local pref
            prefBox.put(
              'mosque',
              mosqueId,
            );

            // sync for offline view
            FirebaseDatabase.instance
                .reference()
                .child('prayerTimes')
                .child(mosqueId)
                .keepSynced(true);

            // set first open to false
            if (prefBox.get('firstOpen')) {
              prefBox.put('firstOpen', false);

              Navigator.pushReplacementNamed(context, '/home');
            } else {
              // update selected date to today so its reset when changing mosques
              _selectedDateController.updateSelectedDate(DateTime.now());
              Navigator.popUntil(context, ModalRoute.withName('/home'));
            }
            filteringController.resetFilter();
            context.read(currentSubsListProvider).autoSubscribe(mosqueId);
          },
        ),
      ),
    );
  }
}
