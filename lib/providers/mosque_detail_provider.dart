import 'package:flutter_riverpod/all.dart';
import 'package:takvim/data/models/mosque_data.dart';

final selectedMosqueDetail =
    StateNotifierProvider<SelectedMosqueDetailIdProvider>((ref) {
  return SelectedMosqueDetailIdProvider();
});

class SelectedMosqueDetailIdProvider extends StateNotifier<MosqueData> {
  SelectedMosqueDetailIdProvider() : super(null);

  void updateSelectedMosque(MosqueData data) {
    this.state = data;
  }
}
