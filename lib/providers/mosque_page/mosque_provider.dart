import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/mosque_data.dart';
import 'package:takvim/providers/firestore_provider.dart';
import '../../data/models/day_data.dart';

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

final mosqueController = StateNotifierProvider<MosqueController>((ref) {
  SelectedMosque _selectedMosque = ref.watch(selectedMosque);
  MosqueList _listOfMosques = ref.watch(mosqueList);
  FilteredMosqueList _filteredMosqueList = ref.watch(filteredMosqueList);
  FirebaseFirestore _firebaseFirestore = ref.watch(firestoreProvider);
  FilterTextField _filterTextField = ref.watch(filterTextField);

  return MosqueController(
    FirebaseDatabase.instance.reference(),
    _selectedMosque,
    _listOfMosques,
    _filteredMosqueList,
    _firebaseFirestore,
    _filterTextField,
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
  ) : super(null);

  final SelectedMosque _selectedMosque;
  final MosqueList _mosqueList;
  final FilteredMosqueList _filteredMosqueList;
  final DatabaseReference _databaseReference;
  final FirebaseFirestore _firebaseFirestore;
  final FilterTextField _filterTextField;

  final Box _prefBox = Hive.box('pref');

  // Stream<List<MosqueData>> watchMosques() {
  //   List<MosqueData> mosqueList = [];
  //   _databaseReference.child('mosques').onValue.listen((event) {
  //     if (event.snapshot.value != null) {
  //       mosqueList = [];
  //       event.snapshot.value.forEach((key, value) {
  //         mosqueList.add(
  //           MosqueData.fromFirebase(value),
  //         );
  //       });
  //       mosqueList.sort((a, b) => a.ort.compareTo(b.ort));
  //       _mosqueList.updateList(mosqueList);
  //       if (_filteredMosqueList.state.isEmpty) {
  //         _filteredMosqueList.updateList(mosqueList);
  //       }
  //     }
  //   });

  //   return Stream.value(mosqueList);
  // }

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

  // Future<List<MosqueData>> getFilteredListOfMosques() async {
  //   List<MosqueData> mosques = [];
  //   final DataSnapshot ref = await _databaseReference.child('mosques').once();

  //   if (ref.value != null) {
  //     ref.value.forEach(
  //       (key, mosque) => {
  //         mosques.add(
  //           MosqueData.fromFirebase(mosque),
  //         ),
  //       },
  //     );
  //   }

  //   return mosques;
  // }

  // Future<List<MosqueData>> getListOfMosques() async {
  //   List<MosqueData> mosques = [];
  //   final DataSnapshot ref =
  //       await _databaseReference.child('mosques').orderByChild('Name').once();

  //   if (ref.value != null) {
  //     ref.value.forEach(
  //       (key, mosque) => {
  //         mosques.add(
  //           MosqueData.fromFirebase(mosque),
  //         ),
  //       },
  //     );
  //   }

  //   _mosqueList.updateList(mosques);
  //   _filteredMosqueList.updateList(mosques);

  //   return mosques;
  // }

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

  // Stream<Event> watchMosque(String id) {
  //   String savedId = Hive.box('pref').get('mosque');
  //   if (id == null) {
  //     if (savedId == null) {
  //       id = '1001';
  //     } else {
  //       id = savedId;
  //     }
  //   }
  //   return _databaseReference.child('mosques').child(id).onValue;
  // }

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

  // Future<MosqueData> getSelectedMosque(String selectedMosque) async {
  //   String mosque = _prefBox.get('mosque');

  //   if (mosque == null) {
  //     _selectedMosque.updateSelectedMosque('1001');
  //     _prefBox.put('mosque', '1001');
  //     mosque = _selectedMosque.state;
  //   } else if (_selectedMosque.state == null) {
  //     _selectedMosque.updateSelectedMosque(mosque);
  //   }

  //   MosqueData mosqueData;

  //   final ref = await _databaseReference.child('mosques').child(mosque).once();

  //   if (ref.value != null) {
  //     mosqueData = MosqueData.fromFirebase(ref.value);
  //   }

  //   return mosqueData;
  // }

  Stream<Event> getPrayersForDate(String date) {
    Stream<Event> ref;
    if (_selectedMosque.state == null) {
      String id = Hive.box('pref').get('mosque');
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

  // Future<DayData> getPrayersForDateF(String date) async {
  //   final DataSnapshot ref = await _databaseReference
  //       .child('prayerTimes')
  //       .child(_selectedMosque.state)
  //       .child(date)
  //       .once();

  //   return DayData.fromFirebase(ref.value);
  // }
}
