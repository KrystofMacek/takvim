import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:MyMosq/common/styling.dart';
import 'package:MyMosq/providers/home_page/date_provider.dart';
import 'package:MyMosq/providers/notification_config_page/notification_config_providers.dart';
import '../../common/utils.dart';

class PrayerTimeItem extends ConsumerWidget {
  const PrayerTimeItem({
    Key key,
    @required this.minor,
    @required this.dataMap,
    @required this.isUpcoming,
    @required this.timeData,
    @required this.timeIndex,
  }) : super(key: key);

  final Map<String, String> dataMap;
  final bool minor;
  final bool isUpcoming;
  final DateTime timeData;
  final int timeIndex;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
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
                    .copyWith(color: CustomColors.mainColor, fontSize: 18),
              ),
              Row(
                children: [
                  NotificationLabel(
                    dataMap: dataMap,
                    timeIndex: timeIndex,
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${dataMap['time']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                                  fontFamily: 'Courier-Prime',
                                  fontSize: 18,
                                  letterSpacing: .3,
                                  fontStyle: FontStyle.italic)
                              .copyWith(color: CustomColors.mainColor),
                        ),
                      ],
                    ),
                  ),
                ],
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
                    .copyWith(fontWeight: FontWeight.normal, fontSize: 20),
              ),
              Row(
                children: [
                  isUpcoming
                      ? Container(
                          padding: EdgeInsets.only(right: 15),
                          child: Center(
                            child: Text(
                              '$remainingDurText',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 10,
                  ),
                  NotificationLabel(
                    dataMap: dataMap,
                    timeIndex: timeIndex,
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${dataMap['time']}',
                          textAlign: TextAlign.center,
                          // style: Theme.of(context).textTheme.bodyText1,
                          style: TextStyle(
                              fontFamily: 'Noto-Mono',
                              fontSize: 20,
                              letterSpacing: .3,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal),
                        ),
                      ],
                    ),
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

class NotificationLabel extends StatelessWidget {
  const NotificationLabel({
    Key key,
    @required this.dataMap,
    @required this.timeIndex,
  }) : super(key: key);

  final Map<String, String> dataMap;
  final int timeIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        DateTime _selectedDate = watch(selectedDate.state);
        bool _showScheduled = false;
        // String scheduledLabel = '';
        List<int> _activeTimes = watch(activeTimesProvider.state);
        // List<int> _minutesBefore = watch(notificationMinutesProvider.state);

        if (_activeTimes.isNotEmpty) {
          if (_activeTimes.contains(timeIndex)) {
            _showScheduled = true;
          }
        }
        return _showScheduled
            ? FaIcon(
                FontAwesomeIcons.bell,
                color: CustomColors.mainColor,
                size: 14,
              )
            : SizedBox();
      },
    );
  }
}
