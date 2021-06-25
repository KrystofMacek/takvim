import 'package:MyMosq/widgets/home_page/prayer_time_data_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:MyMosq/data/models/day_data.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import 'package:MyMosq/providers/common/notification_provider.dart';
import 'package:MyMosq/providers/home_page/date_provider.dart';
import 'package:MyMosq/providers/mosque_page/mosque_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/utils.dart';
import '../../providers/home_page/time_provider.dart';

class DailyDataView extends ConsumerWidget {
  const DailyDataView({
    Key key,
    @required MosqueController mosqueController,
    @required SelectedDate selectedDate,
    @required LanguagePack appLang,
  })  : _mosqueController = mosqueController,
        _selectedDate = selectedDate,
        _appLang = appLang,
        super(key: key);

  final MosqueController _mosqueController;
  final SelectedDate _selectedDate;
  final LanguagePack _appLang;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final dateFormat = DateFormat('yyyyMMdd');
    String tomorrowFormed =
        dateFormat.format(DateTime.now().add(Duration(days: 1)));

    return StreamBuilder<Event>(
      stream: _mosqueController.getPrayersForDate(tomorrowFormed),
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data.snapshot.value != null) {
          DayData tomorrow = DayData.fromFirebase(snapshot.data.snapshot.value);

          context.read(daysToScheduleProvider).updateTomorrow(tomorrow);

          return StreamBuilder<Event>(
            stream:
                _mosqueController.getPrayersForDate(_selectedDate.getDateId()),
            builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData &&
                  !snapshot.hasError &&
                  snapshot.data.snapshot.value != null) {
                DayData data =
                    DayData.fromFirebase(snapshot.data.snapshot.value);

                context.read(daysToScheduleProvider).updateToday(data);
                context
                    .read(notificationController)
                    .scheduleNotification(data, tomorrow);

                return Consumer(
                  builder: (context, watch, child) {
                    int upcoming = _findUpcoming(data);
                    if (_selectedDate.getDateId() !=
                        formatDateToID(DateTime.now())) {
                      upcoming = 20;
                    }
                    return watch(timeProvider).when(
                        data: (timeData) {
                          return PrayerTimeDataView(
                            data: data,
                            appLang: _appLang,
                            upcoming: upcoming,
                            timeData: timeData,
                          );
                        },
                        loading: () => Center(
                              child: CircularProgressIndicator(),
                            ),
                        error: (_, __) => Text('Timer Error'));
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  int _findUpcoming(DayData data) {
    List<int> times = [];
    List<String> values = [
      data.fajr,
      data.sabah,
      data.sunrise,
      data.dhuhrTime,
      data.dhuhr,
      data.asr,
      data.maghrib,
      data.ishaTime,
      data.isha
    ];

    String hour = DateTime.now().hour.toString();
    String minute = getTwoDigitTime(DateTime.now().minute);

    String hourMin = '$hour$minute' + '01';
    times.add(int.parse(hourMin));

    values.forEach((value) {
      int timeValue = getStringTimeAsComparableInt(value + '00');
      times.add(timeValue);
    });
    times.sort();
    int index = times.indexWhere(
        (element) => (element == getStringTimeAsComparableInt(hourMin)));
    return index;
  }
}
