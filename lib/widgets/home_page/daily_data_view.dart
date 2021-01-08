import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takvim/common/constants.dart';
import 'package:takvim/common/styling.dart';
import 'package:takvim/data/models/day_data.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/date_provider.dart';
import 'package:takvim/providers/mosque_provider.dart';
import './prayer_time_item.dart';

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
      stream: _mosqueController.getPrayersForDate(
        _selectedDate.getDateId(),
      ),
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data.snapshot.value != null) {
          DayData data = DayData.fromFirebase(snapshot.data.snapshot.value);

          String isha = data.isha.replaceFirst(":", "");
          String ishaTime = data.ishaTime.replaceFirst(":", "");
          print('replacing : $isha $ishaTime');

          bool skipIshaTime = false;

          if (int.tryParse(ishaTime) >= int.tryParse(isha)) {
            print('swap = true');
            skipIshaTime = true;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemCount: PRAYER_TIMES.length,
                itemBuilder: (context, index) {
                  Map<String, String> dataMap =
                      _getTimeName(index, _appLang, data);

                  bool minor = false;

                  if (index == 0 || index == 2 || index == 6) {
                    minor = true;
                  }

                  if (index == 6 && skipIshaTime) {
                    print('skip = true');
                    return SizedBox();
                  }
                  return PrayerTimeItem(
                    dataMap: dataMap,
                    minor: minor,
                  );
                },
                separatorBuilder: (context, index) {
                  switch (index) {
                    case 2:
                    case 4:
                      return SizedBox(
                        height: 10,
                      );
                    default:
                      return SizedBox(
                        height: 0,
                      );
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  '${data.notes}',
                  style: CustomTextFonts.notesFont,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                ),
              ),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
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
