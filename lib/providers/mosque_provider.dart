import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/mosque_data.dart';

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
    state = data;
  }
}

final mosqueController = StateNotifierProvider<MosqueController>((ref) {
  SelectedMosque _selectedMosque = ref.watch(selectedMosque);
  MosqueList _listOfMosques = ref.watch(mosqueList);
  FilteredMosqueList _filteredMosqueList = ref.watch(filteredMosqueList);
  return MosqueController(
    FirebaseDatabase.instance.reference(),
    _selectedMosque,
    _listOfMosques,
    _filteredMosqueList,
  );
});

class MosqueController extends StateNotifier<MosqueController> {
  MosqueController(
    this._databaseReference,
    this._selectedMosque,
    this._mosqueList,
    this._filteredMosqueList,
  ) : super(null);

  final SelectedMosque _selectedMosque;
  final MosqueList _mosqueList;
  final FilteredMosqueList _filteredMosqueList;
  final DatabaseReference _databaseReference;

  final Box _prefBox = Hive.box('pref');

  Future<List<MosqueData>> getListOfMosques() async {
    print('getListOFMosques');
    List<MosqueData> mosques = [];
    final DataSnapshot ref =
        await _databaseReference.child('mosques').orderByChild('Name').once();
    if (ref.value != null) {
      ref.value.forEach(
        (key, mosque) => {
          mosques.add(
            MosqueData.fromFirebase(mosque),
          ),
        },
      );
    }

    _mosqueList.updateList(mosques);
    _filteredMosqueList.updateList(mosques);

    return mosques;
  }

  void filterMosqueList(String key) {
    List<MosqueData> fullList = _mosqueList.state;
    _filteredMosqueList.updateList(
      fullList
          .where(
            //check name
            (mosque) =>
                (mosque.name.toLowerCase().contains(key.toLowerCase()) ||
                    mosque.kanton.toLowerCase().contains(key.toLowerCase()) ||
                    mosque.ort.toLowerCase().contains(key.toLowerCase())),
          )
          .toList(),
    );
  }

  Future<MosqueData> getSelectedMosque(String selectedMosque) async {
    String mosque = _prefBox.get('mosque');

    print('loaded mosque $mosque');
    if (mosque == null) {
      _selectedMosque.updateSelectedMosque('1001');
      _prefBox.put('mosque', '1001');
      mosque = _selectedMosque.state;
    } else if (_selectedMosque.state == null) {
      _selectedMosque.updateSelectedMosque(mosque);
    }

    MosqueData mosqueData;

    final ref = await _databaseReference.child('mosques').child(mosque).once();

    if (ref.value != null) {
      mosqueData = MosqueData.fromFirebase(ref.value);
    }

    return mosqueData;
  }

  Stream<Event> getPrayersForDate(String date) {
    final Stream<Event> ref = _databaseReference
        .child('prayerTimes')
        .child(_selectedMosque.state)
        .child(date)
        .onValue;

    return ref;
  }
}
