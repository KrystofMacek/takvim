import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:takvim/common/constants.dart';
import 'package:takvim/common/styling.dart';
import 'package:takvim/providers/notification_config_page/notification_config_providers.dart';
import 'package:takvim/widgets/subscription_page/checkbox.dart';

class ConfigTimesView extends StatelessWidget {
  const ConfigTimesView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ConfigTimesItem(
                index: index,
              );
            },
            separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
            itemCount: PRAYER_TIMES.length)
      ],
    );
  }
}

class ConfigTimesItem extends ConsumerWidget {
  const ConfigTimesItem({
    Key key,
    int index,
  })  : _index = index,
        super(key: key);

  final int _index;
  bool _isMinor(int index) =>
      (index == 0 || index == 3 || index == 2 || index == 7);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final bool minor = _isMinor(_index);
    final List<int> _activeTimes = watch(activeTimesProvider.state);
    final List<int> _notificationMinutes =
        watch(notificationMinutesProvider.state);

    final bool _isActive = _activeTimes.contains(_index);
    return Card(
      elevation: minor ? 0 : 1,
      color: minor
          ? Theme.of(context).scaffoldBackgroundColor
          : Theme.of(context).cardColor,
      child: Container(
        padding: minor
            ? EdgeInsets.symmetric(vertical: 0, horizontal: 10)
            : EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () =>
                      context.read(activeTimesProvider).toggleTime(_index),
                  child: CustomCheckBox(
                    size: 25,
                    iconSize: 20,
                    isChecked: _isActive,
                    isDisabled: false,
                    isClickable: true,
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  PRAYER_TIMES[_index],
                  style: minor
                      ? Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: CustomColors.mainColor, fontSize: 18)
                      : Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.normal, fontSize: 20),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    minor
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Colors.white,
                    Colors.lightBlue[50],
                    minor
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Colors.white,
                  ],
                ),
              ),
              child: NumberPicker(
                minValue: 0,
                maxValue: 59,
                value: _notificationMinutes[_index],
                itemHeight: 25,
                itemWidth: 25,
                itemCount: 3,
                axis: Axis.horizontal,
                onChanged: (change) {
                  context
                      .read(notificationMinutesProvider)
                      .updateTime(change, _index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
