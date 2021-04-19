import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:takvim/common/constants.dart';
import 'package:takvim/data/models/day_data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/data/models/localNotification.dart';
import 'package:takvim/providers/language_page/language_provider.dart';
import 'package:takvim/providers/mosque_page/mosque_provider.dart';
import 'package:takvim/providers/notification_config_page/notification_config_providers.dart';

final notificationController = StateNotifierProvider<NotificationController>(
  (ref) => NotificationController(
    ref.watch(notificationProvider),
    ref.watch(activeTimesProvider),
    ref.watch(notificationMinutesProvider),
    ref.watch(appLanguagePackProvider.state),
    ref.watch(pendingNotificationList),
    ref.watch(mosqueController),
  ),
);

class NotificationController extends StateNotifier<NotificationController> {
  NotificationController(
    NotificationProvider notificationProvider,
    ActiveTimes activeTimes,
    TimesNotificationMinutes timesNotificationMinutes,
    LanguagePack activeLanguage,
    PendingNotificationList pendingNotificationList,
    MosqueController mosqueController,
  )   : _notificationProvider = notificationProvider,
        _timesNotificationMinutes = timesNotificationMinutes,
        _activeTimes = activeTimes,
        _activeLanguage = activeLanguage,
        _pendingNotificationList = pendingNotificationList,
        _mosqueController = mosqueController,
        super(null);

  final NotificationProvider _notificationProvider;
  final TimesNotificationMinutes _timesNotificationMinutes;
  final ActiveTimes _activeTimes;
  final LanguagePack _activeLanguage;
  final PendingNotificationList _pendingNotificationList;
  final MosqueController _mosqueController;

  void scheduleNotification(DayData today, DayData tomorrow) async {
    List<LocalNotification> _notifications = [];

    final Map<String, dynamic> dataMap = _activeLanguage.toJson();

    DayData thridDay = await _mosqueController
        .getThridDay(DateTime.now().add(Duration(days: 2)));

    if (_activeTimes.state.isNotEmpty) {
      for (var i = 1; i < 4; i++) {
        for (var j = 0; j < PRAYER_TIMES.length; j++) {
          Map<String, dynamic> map;
          if (i == 1) {
            map = today.toJson();
          } else if (i == 2) {
            map = tomorrow.toJson();
          } else {
            map = thridDay.toJson();
          }
          String timeData = map[PRAYER_TIMES[j]].toString();
          String dateData = map['Date'].toString();

          List<String> timeValues = timeData.split(':');
          List<String> dateValues = dateData.split('.');

          DateTime newNotificationDate = DateTime(
            int.parse(dateValues[2]),
            int.parse(dateValues[1]),
            int.parse(dateValues[0]),
            int.parse(timeValues[0]),
            int.parse(timeValues[1]),
          );

          if (_activeTimes.state.contains(j)) {
            _notifications.add(
              LocalNotification(
                newNotificationDate.subtract(
                  Duration(minutes: _timesNotificationMinutes.state[j]),
                ),
                _timesNotificationMinutes.state[j],
                j,
                timeData,
              ),
            );
          }
        }
      }
      _notifications.removeWhere(
        (element) => element.dateOfNotification.isBefore(DateTime.now()),
      );

      await _notificationProvider.clear().then((_) {
        for (var i = 0; i < _notifications.length; i++) {
          LocalNotification notification = _notifications[i];
          bool skip = false;
          if (i < _notifications.length - 1) {
            skip = notification.timeDisplayed ==
                _notifications[i + 1].timeDisplayed;
          }
          if (!skip) {
            String name = dataMap['${PRAYER_TIMES[notification.nameOfTime]}'];
            print('scheduled: ${notification.dateOfNotification}');
            _notificationProvider.scheduleNotification(
              '$name ${notification.timeDisplayed}',
              '',
              notification.dateOfNotification,
              '${notification.minutesBefore.toString()},${notification.nameOfTime}',
              _notifications.indexOf(notification),
            );
          }
        }
      });
    }
  }
}

final notificationProvider = StateNotifierProvider<NotificationProvider>(
    (ref) => NotificationProvider(ref.watch(pendingNotificationList)));

class NotificationProvider
    extends StateNotifier<FlutterLocalNotificationsPlugin> {
  NotificationProvider(PendingNotificationList pendingNotificationList)
      : _pendingNotificationList = pendingNotificationList,
        super(FlutterLocalNotificationsPlugin());

  BuildContext currentBuildContext;
  PendingNotificationList _pendingNotificationList;

  Future<void> initialize(BuildContext context) async {
    currentBuildContext = context;

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');
    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();

    InitializationSettings initSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    state.initialize(
      initSettings,
      // onSelectNotification: (payload) async {},
    );
  }

  Future<void> clear() async {
    await state.cancelAll();
  }

  // Notification settings
  Future<void> scheduleNotification(
    String title,
    String body,
    DateTime scheduledDate,
    String payload,
    int id,
  ) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'takvim_0',
      'takvim_channel',
      'custom_notif_channel',
      importance: Importance.max,
    );
    IOSNotificationDetails iosDetails = IOSNotificationDetails();
    state.schedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidAllowWhileIdle: true,
      payload: payload,
    );
  }

  Future<void> schedulePeriodically(
    String title,
    String body,
    DateTime scheduledDate,
    String payload,
    int id,
  ) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'takvim_1',
      'takvim_channel',
      'takvim_repeating',
      importance: Importance.max,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: IOSNotificationDetails(),
    );
    // state.zonedSchedule(
    //   id,
    //   title,
    //   body,
    //   scheduledDate,
    //   notificationDetails,
    //   uiLocalNotificationDateInterpretation:
    //       uiLocalNotificationDateInterpretation,
    //   androidAllowWhileIdle: androidAllowWhileIdle,
    // );
    state.showDailyAtTime(
        id,
        title,
        body,
        Time(scheduledDate.hour, scheduledDate.hour, scheduledDate.minute),
        platformChannelSpecifics);
  }

  Future<List<Map<String, String>>> getPendingNotifications() async {
    List<PendingNotificationRequest> pending =
        await state.pendingNotificationRequests();
    List<Map<String, String>> pendingLocal = [];
    print('${pending.length} pendleng');
    pending.forEach((element) {
      List<String> payload = element.payload.split(',');
      String minutesBefore = payload[0];
      String timeIndex = payload[1];

      pendingLocal.add({'mintesBefore': minutesBefore, 'timeIndex': timeIndex});
    });

    return pendingLocal;
  }
}

final pendingNotificationList = StateNotifierProvider<PendingNotificationList>(
    (ref) => PendingNotificationList());

class PendingNotificationList extends StateNotifier<List<Map<String, String>>> {
  PendingNotificationList() : super(<Map<String, String>>[]);

  void update(List<Map<String, String>> list) {
    state = list;
  }

  List<Map<String, String>> get() => state;
}

final daysToScheduleProvider =
    StateNotifierProvider<DaysToSchedule>((ref) => DaysToSchedule());

class DaysToSchedule extends StateNotifier<Map<String, DayData>> {
  DaysToSchedule() : super({'today': null, 'tomorrow': null});

  void updateToday(DayData today) {
    state['today'] = today;
  }

  void updateTomorrow(DayData tomorrow) {
    state['tomorrow'] = tomorrow;
  }
}
