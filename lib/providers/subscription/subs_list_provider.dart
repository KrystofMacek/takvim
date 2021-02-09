import 'package:riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../messaging_provider.dart';

final currentSubsListProvider = StateNotifierProvider(
  (ref) => CurrentSubsList(
    Hive.box('pref'),
    ref.watch(fcmProvider),
  ),
);

class CurrentSubsList extends StateNotifier<List<String>> {
  CurrentSubsList(Box prefBox, FirebaseMessaging fcm)
      : _prefBox = prefBox,
        _fcm = fcm,
        super(prefBox.get('subsList') ?? []);

  final Box _prefBox;
  final FirebaseMessaging _fcm;

  Future<void> addToSubsList(String id) async {
    if (!state.contains(id)) {
      state.add(id);
      state = state;
      _prefBox.put('subsList', state);
      await _fcm.subscribeToTopic(id);
    }
  }

  Future<void> removeFromSubsList(String id) async {
    if (state.contains(id)) {
      state.remove(id);
      state = state;
      _prefBox.put('subsList', state);
      await _fcm.unsubscribeFromTopic(id);
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
