import 'package:MyMosq/widgets/home_page/note_pager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MyMosq/common/constants.dart';
import 'package:MyMosq/data/models/day_data.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import './prayer_time_item.dart';
import '../../common/utils.dart';

class PrayerTimeDataView extends StatelessWidget {
  const PrayerTimeDataView({
    Key key,
    @required LanguagePack appLang,
    @required DayData data,
    @required int upcoming,
    @required DateTime timeData,
  })  : _appLang = appLang,
        _data = data,
        _upcomingBase = upcoming,
        _timeData = timeData,
        super(key: key);

  final LanguagePack _appLang;
  final DayData _data;
  final int _upcomingBase;
  final DateTime _timeData;

  @override
  Widget build(BuildContext context) {
    bool skipIshaTime = skipTime(_data, PRAYER_TIMES[7]);
    bool skipDhuhrTime = skipTime(_data, PRAYER_TIMES[3]);
    int _upcoming = _upcomingBase;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: PRAYER_TIMES.length,
            itemBuilder: (context, index) {
              Map<String, String> dataMap = getTimeName(index, _appLang, _data);

              bool isUpcoming = _upcoming == index;

              bool minor = false;

              if (index == 0 || index == 3 || index == 2 || index == 7) {
                if (isUpcoming) {
                  isUpcoming = false;
                  _upcoming += 1;
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
                timeData: _timeData,
                timeIndex: index,
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 2,
              );
            },
          ),
        ),
        SizedBox(
          height: 4,
        ),
        NotePager(data: _data),
      ],
    );
  }
}
