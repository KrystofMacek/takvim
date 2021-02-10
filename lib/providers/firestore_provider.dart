import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:firebase_database/firebase_database.dart';
import '../data/models/subsTopic.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final subsListStreamProvider =
    StreamProvider.autoDispose<List<SubsTopic>>((ref) {
  List<SubsTopic> subsTopics = [];
  ref
      .watch(
        firestoreProvider,
      )
      .collection(
        'topics',
      )
      .snapshots()
      .listen((event) {
    event.docs.forEach((element) {
      subsTopics.add(SubsTopic.fromJson(element.data()));
    });
    ref.watch(subsFilteringController).initLists(subsTopics);
  });
  return Stream.value(subsTopics);
});

// Filtering
final subsFilteringController =
    StateNotifierProvider<SubsFilteringController>((ref) {
  return SubsFilteringController(
    ref.watch(subsMosqueList),
    ref.watch(subsFilteredMosqueList),
  );
});

class SubsFilteringController extends StateNotifier<SubsFilteringController> {
  SubsFilteringController(
    this._subsMosqueList,
    this._subsFilteredMosqueList,
  ) : super(null);

  final SubsMosqueList _subsMosqueList;
  final SubsFilteredMosqueList _subsFilteredMosqueList;

  void initLists(List<SubsTopic> data) {
    _subsMosqueList.updateList(data);
    _subsFilteredMosqueList.updateList(data);
  }

  void resetFilter() {
    _subsFilteredMosqueList.updateList(_subsMosqueList.state);
  }

  void filterMosqueList(String key) {
    List<SubsTopic> fullList = _subsMosqueList.state;
    _subsFilteredMosqueList.updateList(
      fullList.where(
        //check name
        (mosque) {
          List<String> queryVals = [
            key.toLowerCase(),
            mosque.mosqueName.toLowerCase(),
          ];

          queryVals.asMap().forEach((i, value) {
            value = value.replaceAll(RegExp(r'ë'), 'e');
            value = value.replaceAll(RegExp(r'ü'), 'u');
            value = value.replaceAll(RegExp(r'ö'), 'o');
            value = value.replaceAll(RegExp(r'ä'), 'a');

            queryVals[i] = value;
          });

          return (queryVals[1].contains(queryVals[0]));
        },
      ).toList(),
    );
  }
}

final subsMosqueList = StateNotifierProvider<SubsMosqueList>((ref) {
  return SubsMosqueList();
});

class SubsMosqueList extends StateNotifier<List<SubsTopic>> {
  SubsMosqueList() : super([]);

  void updateList(List<SubsTopic> data) {
    state = data;
  }
}

final subsFilteredMosqueList =
    StateNotifierProvider<SubsFilteredMosqueList>((ref) {
  return SubsFilteredMosqueList();
});

class SubsFilteredMosqueList extends StateNotifier<List<SubsTopic>> {
  SubsFilteredMosqueList() : super([]);

  void updateList(List<SubsTopic> data) {
    data.sort((a, b) => a.mosqueName.compareTo(b.mosqueName));
    state = data;
  }
}
