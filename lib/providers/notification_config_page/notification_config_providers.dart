import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:takvim/common/constants.dart';

final activeTimesProvider =
    StateNotifierProvider<ActiveTimes>((ref) => ActiveTimes());

class ActiveTimes extends StateNotifier<List<int>> {
  ActiveTimes()
      : super(Hive.box('notificationConfig')
            .get('activeTimes', defaultValue: <int>[]));

  void toggleTime(int time) {
    if (state.contains(time)) {
      _remove(time);
    } else {
      _addTime(time);
    }
  }

  void _addTime(int time) {
    state.add(time);
    Hive.box('notificationConfig').put('activeTimes', state);
    state = state;
  }

  void _remove(int time) {
    state.remove(time);
    Hive.box('notificationConfig').put('activeTimes', state);
    state = state;
  }
}

final notificationMinutesProvider =
    StateNotifierProvider<TimesNotificationMinutes>(
        (ref) => TimesNotificationMinutes());

class TimesNotificationMinutes extends StateNotifier<List<int>> {
  TimesNotificationMinutes()
      : super(
          Hive.box('notificationConfig').get(
            'timesMinutes',
            defaultValue: List.generate(PRAYER_TIMES.length, (index) => 5),
          ),
        );

  void updateTime(int minutes, int index) {
    state[index] = minutes;
    Hive.box('notificationConfig').put('timesMinutes', state);
    state = state;
  }
}
