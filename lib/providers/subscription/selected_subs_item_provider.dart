import 'package:riverpod/all.dart';

final selectedSubsItem = StateNotifierProvider<SelectedSubsItem>((ref) {
  return SelectedSubsItem();
});

class SelectedSubsItem extends StateNotifier<String> {
  SelectedSubsItem() : super('');

  void updateSelectedSubsItem(String id) {
    state = id;
  }
}
