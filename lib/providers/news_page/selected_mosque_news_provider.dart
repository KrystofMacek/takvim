import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedMosuqeNewsProvider =
    StateNotifierProvider<SelectedMosuqeNewsProvider>(
        (ref) => SelectedMosuqeNewsProvider());

class SelectedMosuqeNewsProvider extends StateNotifier<String> {
  SelectedMosuqeNewsProvider() : super('');

  void updateSelectedMosqueNews(String mosqueId) {
    state = mosqueId;
  }
}
