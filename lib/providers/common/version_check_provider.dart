import 'package:flutter_riverpod/all.dart';

final versionCheckProvider =
    StateNotifierProvider<VersionCheck>((ref) => VersionCheck());

class VersionCheck extends StateNotifier<bool> {
  VersionCheck() : super(true);

  void update(bool show) => state = show;

  bool get state;
}
