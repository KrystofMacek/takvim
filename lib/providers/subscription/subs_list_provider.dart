import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:takvim/providers/firestore_provider.dart';

import '../../data/models/subsTopic.dart';

final currentSubsListProvider = StateNotifierProvider(
  (ref) => CurrentSubsList(
      Hive.box('pref'),
      FirebaseMessaging(),
      ref.watch(subsBlacklistProvider),
      ref.watch(subsWhitelistProvider),
      ref.watch(firestoreProvider)),
);

class CurrentSubsList extends StateNotifier<List<SubsTopic>> {
  CurrentSubsList(
    Box prefBox,
    FirebaseMessaging fcm,
    SubsBlacklist blacklist,
    SubsWhitelist whitelist,
    FirebaseFirestore firestore,
  )   : _prefBox = prefBox,
        _fcm = fcm,
        _blacklist = blacklist,
        _whitelist = whitelist,
        _firestore = firestore,
        super(prefBox
            .get('subsList', defaultValue: <SubsTopic>[]).cast<SubsTopic>());

  final Box _prefBox;
  final FirebaseMessaging _fcm;
  final SubsBlacklist _blacklist;
  final SubsWhitelist _whitelist;
  final FirebaseFirestore _firestore;

  Future<void> addToSubsList(SubsTopic subsTopic) async {
    if (!state.contains(subsTopic)) {
      state.add(subsTopic);
      state = state;
      _prefBox.put('subsList', state);

      if (_blacklist.state.contains(subsTopic)) {
        _blacklist.removeFromBlacklist(subsTopic);
      } else {
        _whitelist.addToWhitelist(subsTopic);
      }

      await _fcm.subscribeToTopic(subsTopic.topic);
    }
  }

  Future<void> removeFromSubsList(SubsTopic subsTopic) async {
    if (state.contains(subsTopic)) {
      state.remove(subsTopic);
      state = state;
      _prefBox.put('subsList', state);

      if (_whitelist.state.contains(subsTopic)) {
        _whitelist.removeFromWhitelist(subsTopic);
      } else {
        _blacklist.addToBlacklist(subsTopic);
      }

      await _fcm.unsubscribeFromTopic(subsTopic.topic);
    }
  }

  void autoSubscribe(String mosqueId) async {
    List<SubsTopic> newMosqueTopics = [];
    QuerySnapshot snap = await _firestore
        .collection('topics')
        .where('mosqueId', isEqualTo: mosqueId)
        .get();
    snap.docs.forEach((element) {
      newMosqueTopics.add(SubsTopic.fromJson(element.id, element.data()));
    });

    List<SubsTopic> toUnsub = [];
    // UNSUB from NON W-Listed
    for (var topic in state) {
      if (!_whitelist.state.contains(topic)) {
        toUnsub.add(topic);
      }
    }
    for (var topic in toUnsub) {
      state.remove(topic);
      state = state;
      _prefBox.put('subsList', state);

      await _fcm.unsubscribeFromTopic(topic.topic);
    }

    List<SubsTopic> toSub = [];
    // SUB to NOT B-Listed
    for (var topic in newMosqueTopics) {
      if (!_blacklist.state.contains(topic)) {
        toSub.add(topic);
      }
    }
    for (var topic in toSub) {
      state.add(topic);
      state = state;
      _prefBox.put('subsList', state);

      await _fcm.subscribeToTopic(topic.topic);
    }
  }
}

final currentMosqueSubs =
    StateNotifierProvider((ref) => CurrentMosqueSubs(Hive.box('pref')));

class CurrentMosqueSubs extends StateNotifier<List<String>> {
  CurrentMosqueSubs(Box prefBox)
      : _prefBox = prefBox,
        super(prefBox.get('mosqueSubsList') ?? []);

  final Box _prefBox;

  void addMosqueToSubsList(String id) {
    if (!state.contains(id)) {
      state.add(id);
      state = state;
      _prefBox.put('mosqueSubsList', state);
    }
  }

  void removeMosqueFromSubsList(String id) {
    if (state.contains(id)) {
      state.remove(id);
      state = state;
      _prefBox.put('mosqueSubsList', state);
    }
  }
}

final subsWhitelistProvider = StateNotifierProvider(
  (ref) => SubsWhitelist(
    Hive.box('pref'),
  ),
);

class SubsWhitelist extends StateNotifier<List<SubsTopic>> {
  SubsWhitelist(
    Box prefBox,
  )   : _prefBox = prefBox,
        super(
          prefBox.get('subsWhiteList',
              defaultValue: <SubsTopic>[]).cast<SubsTopic>(),
        );

  final Box _prefBox;

  void removeFromWhitelist(SubsTopic topic) {
    if (state.contains(topic)) {
      state.remove(topic);
      state = state;
      _prefBox.put('subsWhiteList', state);
    }
  }

  void addToWhitelist(SubsTopic topic) {
    if (!state.contains(topic)) {
      state.add(topic);
      state = state;
      _prefBox.put('subsWhiteList', state);
    }
  }
}

final subsBlacklistProvider = StateNotifierProvider(
  (ref) => SubsBlacklist(
    Hive.box('pref'),
  ),
);

class SubsBlacklist extends StateNotifier<List<SubsTopic>> {
  SubsBlacklist(
    Box prefBox,
  )   : _prefBox = prefBox,
        super(
          prefBox.get('subsBlackList',
              defaultValue: <SubsTopic>[]).cast<SubsTopic>(),
        );

  final Box _prefBox;

  void removeFromBlacklist(SubsTopic topic) {
    if (state.contains(topic)) {
      state.remove(topic);
      state = state;
      _prefBox.put('subsBlackList', state);
    }
  }

  void addToBlacklist(SubsTopic topic) {
    if (!state.contains(topic)) {
      state.add(topic);
      state = state;
      _prefBox.put('subsBlackList', state);
    }
  }
}
