import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:MyMosq/common/utils.dart';
import 'package:MyMosq/data/models/day_data.dart';
import 'package:MyMosq/data/models/mosque_data.dart';
import 'package:MyMosq/providers/common/geolocator_provider.dart';
import 'package:MyMosq/providers/firestore_provider.dart';
import 'package:geolocator/geolocator.dart';

final tempSelectedMosque = StateNotifierProvider<TempSelectedMosque>((ref) {
  return TempSelectedMosque(ref.watch(selectedMosque.state));
});

class TempSelectedMosque extends StateNotifier<String> {
  TempSelectedMosque(String id) : super(id);

  String getTempSelectedMosqueId() => state;

  void updateTempSelectedMosque(String id) {
    state = id;
  }
}

final selectedMosque = StateNotifierProvider<SelectedMosque>((ref) {
  return SelectedMosque();
});

class SelectedMosque extends StateNotifier<String> {
  SelectedMosque() : super(null);

  String getSelectedMosqueId() => state;

  void updateSelectedMosque(String id) {
    final Box _prefBox = Hive.box('pref');
    _prefBox.put('mosque', id);
    state = id;
  }

  void selectedMosqueWasChanged(String id) {
    final Box _prefBox = Hive.box('pref');
    _prefBox.put('mosque', id);
    state = id;
  }
}

final mosqueList = StateNotifierProvider<MosqueList>((ref) {
  return MosqueList();
});

class MosqueList extends StateNotifier<List<MosqueData>> {
  MosqueList() : super([]);

  void updateList(List<MosqueData> data) {
    state = data;
  }
}

final filteredMosqueList = StateNotifierProvider<FilteredMosqueList>((ref) {
  return FilteredMosqueList();
});

class FilteredMosqueList extends StateNotifier<List<MosqueData>> {
  FilteredMosqueList() : super([]);

  void updateList(List<MosqueData> data) {
    data.sort((a, b) => a.ort.compareTo(b.ort));
    state = data;
  }
}

final filterTextField = StateNotifierProvider<FilterTextField>((ref) {
  return FilterTextField();
});

class FilterTextField extends StateNotifier<String> {
  FilterTextField() : super('');

  void updateText(String data) {
    state = data;
  }
}

final sortByDistanceToggle = StateNotifierProvider<SortByDistanceToggle>((ref) {
  return SortByDistanceToggle();
});

class SortByDistanceToggle extends StateNotifier<bool> {
  SortByDistanceToggle() : super(false);

  void toggle() {
    state = !state;
  }
}

final mosqueController = StateNotifierProvider<MosqueController>((ref) {
  SelectedMosque _selectedMosque = ref.watch(selectedMosque);
  MosqueList _listOfMosques = ref.watch(mosqueList);
  FilteredMosqueList _filteredMosqueList = ref.watch(filteredMosqueList);
  FirebaseFirestore _firebaseFirestore = ref.watch(firestoreProvider);
  FilterTextField _filterTextField = ref.watch(filterTextField);
  UsersPosition _usersPosition = ref.watch(usersPosition);

  return MosqueController(
    FirebaseDatabase.instance.reference(),
    _selectedMosque,
    _listOfMosques,
    _filteredMosqueList,
    _firebaseFirestore,
    _filterTextField,
    _usersPosition,
  );
});

class MosqueController extends StateNotifier<MosqueController> {
  MosqueController(
    this._databaseReference,
    this._selectedMosque,
    this._mosqueList,
    this._filteredMosqueList,
    this._firebaseFirestore,
    this._filterTextField,
    this._usersPosition,
  ) : super(null);

  final SelectedMosque _selectedMosque;
  final MosqueList _mosqueList;
  final FilteredMosqueList _filteredMosqueList;
  final DatabaseReference _databaseReference;
  final FirebaseFirestore _firebaseFirestore;
  final FilterTextField _filterTextField;
  final UsersPosition _usersPosition;

  final Box _prefBox = Hive.box('pref');

  Stream<List<MosqueData>> watchPrayerTimeFirestoreMosques() {
    List<MosqueData> mosqueList = [];
    _firebaseFirestore
        .collection('mosques')
        .where('prayerTimesEnabled', isEqualTo: true)
        .snapshots()
        .listen((event) {
      if (event.docs != null && event.docs.isNotEmpty) {
        mosqueList = [];
        event.docs.forEach((element) {
          MosqueData _newMosque = MosqueData.fromJson(element.data());

          mosqueList.add(_newMosque);
        });

        mosqueList = updateDistances(mosqueList);
        _mosqueList.updateList(mosqueList);

        if (_filterTextField.state.isEmpty) {
          _filteredMosqueList.updateList(mosqueList);
        }
      }
    });

    return Stream.value(mosqueList);
  }

  List<MosqueData> updateDistances(List<MosqueData> data) {
    List<MosqueData> newList = [];

    if (_usersPosition.state != null) {
      data.forEach((element) {
        double dist = Geolocator.distanceBetween(
                _usersPosition.state.latitude,
                _usersPosition.state.longitude,
                element.coords['lat'],
                element.coords['lng']) /
            1000;

        MosqueData _newMosque = element.copyWith(distance: dist);
        newList.add(_newMosque);
      });
    } else {
      newList = data;
    }
    return newList;
  }

  Stream<List<MosqueData>> watchSubscribableFirestoreMosques() {
    List<MosqueData> mosqueList = [];
    _firebaseFirestore
        .collection('mosques')
        .where('postsEnabledApp', isEqualTo: true)
        .snapshots()
        .listen((event) {
      if (event.docs != null && event.docs.isNotEmpty) {
        mosqueList = [];
        event.docs.forEach((element) {
          mosqueList.add(MosqueData.fromJson(element.data()));
        });
        mosqueList.sort((a, b) => a.ort.compareTo(b.ort));
        _mosqueList.updateList(mosqueList);

        if (_filterTextField.state.isEmpty) {
          _filteredMosqueList.updateList(mosqueList);
        }
      }
    });

    return Stream.value(mosqueList);
  }

  void resetFilter() {
    _filteredMosqueList.updateList(_mosqueList.state);
  }

  void filterMosqueList(String key) {
    List<MosqueData> fullList = _mosqueList.state;
    _filteredMosqueList.updateList(
      fullList.where(
        //check name
        (mosque) {
          List<String> queryVals = [
            key.toLowerCase(),
            mosque.name.toLowerCase(),
            mosque.kanton.toLowerCase(),
            mosque.ort.toLowerCase()
          ];

          queryVals.asMap().forEach((i, value) {
            value = value.replaceAll(RegExp(r'ë'), 'e');
            value = value.replaceAll(RegExp(r'é'), 'e');
            value = value.replaceAll(RegExp(r'è'), 'e');
            value = value.replaceAll(RegExp(r'ü'), 'u');
            value = value.replaceAll(RegExp(r'ö'), 'o');
            value = value.replaceAll(RegExp(r'ä'), 'a');
            value = value.replaceAll(RegExp(r'à'), 'a');

            queryVals[i] = value;
          });

          return (queryVals[3].contains(queryVals[0]) ||
              queryVals[2].contains(queryVals[0]) ||
              queryVals[1].contains(queryVals[0]));
        },
      ).toList(),
    );
  }

  Stream<QuerySnapshot> watchFirestoreMosque(String id) {
    String savedId = Hive.box('pref').get('mosque');
    if (id == null) {
      if (savedId == null) {
        id = '1001';
      } else {
        id = savedId;
      }
    }

    return _firebaseFirestore
        .collection('mosques')
        .where('MosqueID', isEqualTo: id)
        .snapshots();
  }

  Stream<Event> getPrayersForDate(String date) {
    Stream<Event> ref;

    if (_selectedMosque.state == null) {
      String id = Hive.box('pref').get('mosque');
      print(id);
      ref =
          _databaseReference.child('prayerTimes').child(id).child(date).onValue;
    } else {
      ref = _databaseReference
          .child('prayerTimes')
          .child(_selectedMosque.state)
          .child(date)
          .onValue;
    }

    return ref;
  }

  Future<DayData> getThridDay(DateTime date) async {
    DataSnapshot data;

    if (_selectedMosque.state == null) {
      String id = Hive.box('pref').get('mosque');
      print(id);
      data = await _databaseReference
          .child('prayerTimes')
          .child(id)
          .child(formatDateToID(date))
          .once();
    } else {
      data = await _databaseReference
          .child('prayerTimes')
          .child(_selectedMosque.state)
          .child(formatDateToID(date))
          .once();
    }

    return DayData.fromFirebase(data.value);
  }
}
