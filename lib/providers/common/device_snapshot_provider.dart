import 'dart:io';

import 'package:MyMosq/data/models/subsTopic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:MyMosq/providers/firestore_provider.dart';
import 'package:MyMosq/providers/mosque_page/mosque_provider.dart';
import 'package:MyMosq/providers/subscription/subs_list_provider.dart';
import 'package:geocoder/geocoder.dart';

final deviceSnapshotProvider =
    StateNotifierProvider<DeviceSnapshot>((ref) => DeviceSnapshot(
          ref.watch(firestoreProvider),
          ref.watch(selectedMosque),
        ));

class DeviceSnapshot extends StateNotifier<DateTime> {
  DeviceSnapshot(
    FirebaseFirestore firebaseFirestore,
    SelectedMosque selectedMosque,
  )   : _firestore = firebaseFirestore,
        _selectedMosque = selectedMosque,
        super(
            Hive.box('pref').get('lastCheckIn', defaultValue: DateTime(2021)));

  FirebaseFirestore _firestore;
  SelectedMosque _selectedMosque;

  void updateSnapshot(bool configChange) async {
    DocumentSnapshot doc =
        await _firestore.collection('settings').doc('statistics').get();

    int fq = doc.get('phoneLastCheckinFrequency');
    List<SubsTopic> _currentSubsList = Hive.box('pref')
        .get('subsList', defaultValue: <SubsTopic>[]).cast<SubsTopic>();

    if (state.difference(DateTime.now()).inHours.abs() >= fq || configChange) {
      Hive.box('pref').put('lastCheckIn', DateTime.now());
      FieldValue _timestamp = FieldValue.serverTimestamp();

      String id = await FirebaseMessaging().getToken();

      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      String _deviceManufacturer = '';
      String _model = '';
      String _os = '';
      String _osVersion = '';
      String _selectedMosqueId = _selectedMosque.getSelectedMosqueId();
      String _selectedLangId = Hive.box('pref').get('appLang');
      FieldValue _lastCheckIn = _timestamp;

      List<String> subs = [];

      if (_currentSubsList != null) {
        _currentSubsList.forEach((element) {
          if (!subs.contains(element.topic)) {
            subs.add(element.topic);
          }
        });
      }

      Position _currentPosition;
      String address = '';
      LocationPermission loc = await Geolocator.checkPermission();
      if (loc == LocationPermission.always ||
          loc == LocationPermission.whileInUse) {
        _currentPosition = await Geolocator.getCurrentPosition();
        List<Address> addresses = await Geocoder.local
            .findAddressesFromCoordinates(Coordinates(
                _currentPosition.latitude, _currentPosition.longitude));

        if (addresses != null && addresses.isNotEmpty) {
          String country = addresses.first.countryName;
          String reg = addresses.first.adminArea;
          String city = addresses.first.subAdminArea;
          address = '$city, $reg, $country';
        }
      }

      if (Platform.isAndroid) {
        await deviceInfo.androidInfo.then((info) {
          _deviceManufacturer = info.manufacturer;
          _model = info.model;
          _os = Platform.operatingSystem;
          _osVersion = info.version.release;
        });
      } else if (Platform.isIOS) {
        await deviceInfo.iosInfo.then((info) {
          _deviceManufacturer = 'Apple';
          _model = info.utsname.machine;
          _os = Platform.operatingSystem;
          _osVersion = Platform.operatingSystemVersion;
        });
      }

      DocumentSnapshot snap =
          await _firestore.collection('deviceSnapshots').doc(id).get();

      Map<String, dynamic> data = snap.data();

      if (data != null && address == '' && data['location'] != '') {
        _firestore.collection('deviceSnapshots').doc(id).update(
          {
            'deviceManufacturer': _deviceManufacturer,
            'deviceModel': _model,
            'deviceOsType': _os,
            'deviceOsVersion': _osVersion,
            'lastCheckIn': _lastCheckIn,
            'mosqueId': _selectedMosqueId,
            'languageId': _selectedLangId,
            'subscriptions': subs,
          },
        );
      } else {
        _firestore.collection('deviceSnapshots').doc(id).set(
          {
            'deviceManufacturer': _deviceManufacturer,
            'deviceModel': _model,
            'deviceOsType': _os,
            'deviceOsVersion': _osVersion,
            'lastCheckIn': _lastCheckIn,
            'mosqueId': _selectedMosqueId,
            'languageId': _selectedLangId,
            'subscriptions': subs,
            'location': address,
          },
        );
      }
    }
  }
}
