import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takvim/common/constants.dart';
import 'package:takvim/data/models/day_data.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/date_provider.dart';
import 'package:takvim/providers/mosque_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './prayer_time_item.dart';
import '../../common/utils.dart';
import '../../providers/time_provider.dart';

class DailyDataView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return StreamBuilder<Event>(
      stream: _mosqueController.getPrayersForDate(_selectedDate.getDateId()),
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data.snapshot.value != null) {
          DayData data = DayData.fromFirebase(snapshot.data.snapshot.value);

          bool skipIshaTime = _skipTime(data, PRAYER_TIMES[7]);
          bool skipDhuhrTime = _skipTime(data, PRAYER_TIMES[3]);

          return Consumer(
            builder: (context, watch, child) {
              int upcoming = _findUpcoming(data);
              if (_selectedDate.getDateId() != formatDateToID(DateTime.now())) {
                upcoming = 20;
              }
              return watch(timeProvider).when(
                  data: (timeData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: PRAYER_TIMES.length,
                          itemBuilder: (context, index) {
                            Map<String, String> dataMap =
                                _getTimeName(index, _appLang, data);

                            bool isUpcoming = upcoming == index;

                            bool minor = false;

                            if (index == 0 ||
                                index == 3 ||
                                index == 2 ||
                                index == 7) {
                              if (isUpcoming) {
                                isUpcoming = false;
                                upcoming += 1;
                              }
                              minor = true;
                            }

                            if (index == 7 && skipIshaTime) {
                              return SizedBox();
                            }
                            if (index == 3 && skipDhuhrTime) {
                              return SizedBox();
                            }
                            return PrayerTimeItem(
                                dataMap: dataMap,
                                minor: minor,
                                isUpcoming: isUpcoming,
                                timeData: timeData);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 2,
                            );
                          },
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        /*Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: data.notes.isNotEmpty
                                  ? Theme.of(context).colorScheme.surface
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: AutoSizeText(
                              '${data.notes}',
                              style: Theme.of(context).textTheme.headline3,
                              textAlign: TextAlign.center,
                              maxLines: 5,
                            ),
                          ),
                        ),*/
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 115),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: data.notes.isNotEmpty
                                      ? Theme.of(context).colorScheme.surface
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: SingleChildScrollView(
                                  child: Text(
                                    '${data.notes}',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => Center(
                        child: CircularProgressIndicator(),
                      ),
                  error: (_, __) => Text('Timer Error'));
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  bool _skipTime(DayData data, String time) {
    bool skip = false;
    switch (time) {
      case 'IshaTime':
        String isha = data.isha.replaceFirst(":", "");
        String ishaTime = data.ishaTime.replaceFirst(":", "");

        if (int.tryParse(ishaTime) >= int.tryParse(isha)) {
          skip = true;
        }
        break;
      case 'DhuhrTime':
        String dhuhr = data.dhuhr.replaceFirst(":", "");
        String dhuhrTime = data.dhuhrTime.replaceFirst(":", "");

        if (int.tryParse(dhuhrTime) >= int.tryParse(dhuhr)) {
          skip = true;
        }
        break;
      default:
    }

    return skip;
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

  Map<String, String> _getTimeName(int index, LanguagePack lang, DayData data) {
    Map<String, String> timeName = {
      "name": '',
      "time": '',
    };
    switch (PRAYER_TIMES[index]) {
      case 'Fajr':
        timeName.update('name', (value) => lang.fajr);
        timeName.update('time', (value) => data.fajr);
        break;
      case 'Sabah':
        timeName.update('name', (value) => lang.sabah);
        timeName.update('time', (value) => data.sabah);
        break;
      case 'Sunrise':
        timeName.update('name', (value) => lang.sunrise);
        timeName.update('time', (value) => data.sunrise);
        break;
      case 'Dhuhr':
        timeName.update('name', (value) => lang.dhuhr);
        timeName.update('time', (value) => data.dhuhr);
        break;
      case 'DhuhrTime':
        timeName.update('name', (value) => lang.dhuhrTime);
        timeName.update('time', (value) => data.dhuhrTime);
        break;
      case 'Asr':
        timeName.update('name', (value) => lang.asr);
        timeName.update('time', (value) => data.asr);
        break;
      case 'Maghrib':
        timeName.update('name', (value) => lang.maghrib);
        timeName.update('time', (value) => data.maghrib);
        break;
      case 'IshaTime':
        timeName.update('name', (value) => lang.ishaTime);
        timeName.update('time', (value) => data.ishaTime);
        break;
      case 'Isha':
        timeName.update('name', (value) => lang.isha);
        timeName.update('time', (value) => data.isha);
        break;

      default:
        break;
    }

    return timeName;
  }
}
