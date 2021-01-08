import 'package:flutter/material.dart';
import 'package:takvim/common/styling.dart';

class PrayerTimeItem extends StatelessWidget {
  const PrayerTimeItem({
    Key key,
    bool this.minor,
    @required this.dataMap,
  }) : super(key: key);

  final Map<String, String> dataMap;
  final bool minor;

  @override
  Widget build(BuildContext context) {
    if (minor) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${dataMap['name']}',
                style: CustomTextFonts.prayerTimesMain,
              ),
              Text(
                '${dataMap['time']}',
                style: CustomTextFonts.prayerTimesMain,
              ),
            ],
          ),
        ),
      );
    }
  }
}
