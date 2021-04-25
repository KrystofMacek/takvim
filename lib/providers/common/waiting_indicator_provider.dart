import 'package:flutter_riverpod/all.dart';

final waitingIndicatorProvider =
    StateNotifierProvider<WaitingIndicator>((ref) => WaitingIndicator());

class WaitingIndicator extends StateNotifier<bool> {
  WaitingIndicator() : super(false);

  void toggle() => state = !state;
}
