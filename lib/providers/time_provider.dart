import 'package:flutter_riverpod/flutter_riverpod.dart';

final timeProvider = StreamProvider.autoDispose<DateTime>((ref) {
  return Stream<DateTime>.periodic(Duration(seconds: 1), (count) {
    return DateTime.now();
  });
});
