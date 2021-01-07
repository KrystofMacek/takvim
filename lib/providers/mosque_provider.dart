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

  void updateSelectedMosque(String id) {
    final Box _prefBox = Hive.box('pref');
    _prefBox.put('mosque', id);
    state = id;
  }
}

final mosqueController = StateNotifierProvider<MosqueController>((ref) {
  SelectedMosque _selectedMosque = ref.watch(selectedMosque);
  ListOfMosques _listOfMosques = ref.watch(listOfMosques);
  return MosqueController(
    FirebaseDatabase.instance.reference(),
    _selectedMosque,
    _listOfMosques,
  );
});

class MosqueController extends StateNotifier<MosqueController> {
  MosqueController(
      this._databaseReference, this._selectedMosque, this._listOfMosques)
      : super(null);

  final SelectedMosque _selectedMosque;
  final ListOfMosques _listOfMosques;
  final DatabaseReference _databaseReference;

  final Box _prefBox = Hive.box('pref');

  Future<List<MosqueData>> getListOfMosques() async {
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

    return mosques;
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

final listOfMosques = StateNotifierProvider<ListOfMosques>((ref) {
  return ListOfMosques();
});

class ListOfMosques extends StateNotifier<List<MosqueData>> {
  ListOfMosques() : super([]);

  void updateList(List<MosqueData> data) {
    state = data;
  }
}
