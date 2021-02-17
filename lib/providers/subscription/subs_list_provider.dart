import 'package:riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../data/models/subsTopic.dart';

final currentSubsListProvider = StateNotifierProvider(
  (ref) => CurrentSubsList(
    Hive.box('pref'),
    FirebaseMessaging(),
  ),
);

class CurrentSubsList extends StateNotifier<List<SubsTopic>> {
  CurrentSubsList(Box prefBox, FirebaseMessaging fcm)
      : _prefBox = prefBox,
        _fcm = fcm,
        super(prefBox
            .get('subsList', defaultValue: <SubsTopic>[]).cast<SubsTopic>());

  final Box _prefBox;
  final FirebaseMessaging _fcm;

  Future<void> addToSubsList(SubsTopic subsTopic) async {
    if (!state.contains(subsTopic)) {
      state.add(subsTopic);
      state = state;
      _prefBox.put('subsList', state);
      await _fcm.subscribeToTopic(subsTopic.topic);
    }
    print('currentSubs: $state');
  }

  Future<void> removeFromSubsList(SubsTopic subsTopic) async {
    if (state.contains(subsTopic)) {
      state.remove(subsTopic);
      state = state;
      _prefBox.put('subsList', state);
      await _fcm.unsubscribeFromTopic(subsTopic.topic);
    }
    print('currentSubs: $state');
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
