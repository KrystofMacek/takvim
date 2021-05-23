import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:takvim/providers/firestore_provider.dart';
import 'package:takvim/providers/language_page/language_provider.dart';
import 'package:takvim/providers/mosque_page/mosque_provider.dart';
import 'package:takvim/providers/subscription/subs_list_provider.dart';
import 'package:geocoder/geocoder.dart';

final deviceSnapshotProvider =
    StateNotifierProvider<DeviceSnapshot>((ref) => DeviceSnapshot(
          ref.watch(firestoreProvider),
          ref.watch(selectedMosque),
          ref.watch(currentSubsListProvider),
        ));

class DeviceSnapshot extends StateNotifier<DateTime> {
  DeviceSnapshot(
    FirebaseFirestore firebaseFirestore,
    SelectedMosque selectedMosque,
    CurrentSubsList currentSubsList,
  )   : _firestore = firebaseFirestore,
        _selectedMosque = selectedMosque,
        _currentSubsList = currentSubsList,
        super(
            Hive.box('pref').get('lastCheckIn', defaultValue: DateTime(2021)));

  FirebaseFirestore _firestore;
  SelectedMosque _selectedMosque;
  CurrentSubsList _currentSubsList;

  void updateSnapshot(bool configChange) async {
    if (state.difference(DateTime.now()).inHours.abs() >= 12 || configChange) {
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
        _currentSubsList.state.forEach((element) {
          subs.add(element.topic);
        });
      }

      Position _currentPosition;
      String address = '';
      if (await Geolocator.checkPermission() == LocationPermission.always) {
        _currentPosition = await Geolocator.getCurrentPosition();
        List<Address> addresses = await Geocoder.local
            .findAddressesFromCoordinates(Coordinates(
                _currentPosition.latitude, _currentPosition.longitude));

        if (addresses != null && addresses.isNotEmpty) {
          String country = addresses.first.countryName;
          String reg = addresses.first.adminArea;
          String city = addresses.first.subAdminArea;
          address = '$city, $reg, $country';
          print(address);
        }
      }

      if (Platform.isAndroid) {
        await deviceInfo.androidInfo.then((info) {
          _deviceManufacturer = info.manufacturer;
          _model = info.model;
          _os = Platform.operatingSystem;
          _osVersion = Platform.operatingSystemVersion;
        });
      } else if (Platform.isIOS) {
        await deviceInfo.iosInfo.then((info) {
          _deviceManufacturer = 'Apple';
          _model = info.utsname.machine;
          _os = Platform.operatingSystem;
          _osVersion = Platform.operatingSystemVersion;
        });
      }

      _firestore
          .collection('statistics')
          .doc('statistics')
          .collection('deviceSnapshots')
          .doc(id)
          .set(
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
