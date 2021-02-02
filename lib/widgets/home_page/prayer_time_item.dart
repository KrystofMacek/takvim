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
      return Card(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${dataMap['name']}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: CustomColors.mainColor, fontSize: 16),
              ),
              Text(
                '${dataMap['time']}',
                textAlign: TextAlign.center,
                style: TextStyle(
                        fontFamily: 'Courier-Prime',
                        fontSize: 16,
                        letterSpacing: .3,
                        fontStyle: FontStyle.italic)
                    .copyWith(color: CustomColors.mainColor),
              ),
            ],
          ),
        ),
      );
    } else {
      return Card(
        elevation: 1,
        color: isUpcoming
            ? Theme.of(context).colorScheme.primaryVariant
            : Theme.of(context).cardColor,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${dataMap['name']}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  isUpcoming
                      ? Container(
                          padding: EdgeInsets.only(right: 15),
                          child: Center(
                            child: Text(
                              '$remainingDurText',
                              style: TextStyle(
                                  fontFamily: 'Noto-Mono',
                                  fontSize: 16,
                                  letterSpacing: .3,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '${dataMap['time']}',
                    textAlign: TextAlign.center,
                    // style: Theme.of(context).textTheme.bodyText1,
                    style: TextStyle(
                        fontFamily: 'Noto-Mono',
                        fontSize: 16,
                        letterSpacing: .3,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
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
