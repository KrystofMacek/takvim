import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/subsTopic.dart';

final hiddenTopics = StateNotifierProvider(
  (ref) => HiddenTopics(),
);

class HiddenTopics extends StateNotifier<List<String>> {
  HiddenTopics() : super(<String>[]);

  void init() {}

  void hideTopic(String subsTopic) async {
    state.add(subsTopic);
    state = state;
  }

  void showTopic(String subsTopic) async {
    state.remove(subsTopic);
    state = state;
  }
}
