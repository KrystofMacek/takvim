import 'package:flutter/material.dart';
import 'package:takvim/common/styling.dart';
import '../../common/utils.dart';

class PrayerTimeItem extends StatelessWidget {
  const PrayerTimeItem({
    Key key,
    @required this.minor,
    @required this.dataMap,
    @required this.isUpcoming,
    @required this.timeData,
  }) : super(key: key);

  final Map<String, String> dataMap;
  final bool minor;
  final bool isUpcoming;
  final DateTime timeData;

  @override
  Widget build(BuildContext context) {
    DateTime timeOfPrayer = getDateTimeOfParyer(dataMap['time']);

    int diff = timeOfPrayer.difference(timeData).inSeconds;
    Duration remainingDur = Duration(seconds: diff);
    String remainingDurText = remainingDur.toString().split('.')[0];

    if (minor) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${dataMap['name']}',
              style: CustomTextFonts.prayerTimesMinor,
            ),
            Text(
              '${dataMap['time']}',
              style: CustomTextFonts.prayerTimesMinor,
            ),
          ],
        ),
      );
    } else {
      return Card(
        elevation: 2,
        shadowColor: CustomColors.highlightColor,
        color: isUpcoming ? CustomColors.highlightColor : Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${dataMap['name']}',
                style: CustomTextFonts.contentText,
              ),
              Row(
                children: [
                  isUpcoming
                      ? Text(
                          '$remainingDurText',
                          style: CustomTextFonts.countDownNumbers,
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '${dataMap['time']}',
                    style: CustomTextFonts.prayerTimesMain,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
