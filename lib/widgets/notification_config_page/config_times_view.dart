import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:MyMosq/common/constants.dart';
import 'package:MyMosq/common/styling.dart';
import 'package:MyMosq/common/utils.dart';
import 'package:MyMosq/data/models/day_data.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import 'package:MyMosq/providers/common/notification_provider.dart';
import 'package:MyMosq/providers/language_page/language_provider.dart';
import 'package:MyMosq/providers/notification_config_page/notification_config_providers.dart';
import 'package:MyMosq/widgets/subscription_page/checkbox.dart';
// import './custom_dropdown.dart' as custom;

class ConfigTimesView extends ConsumerWidget {
  const ConfigTimesView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final LanguagePack _langPack = watch(appLanguagePackProvider.state);
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.only(left: 8),
                child: Text(_langPack.activate)),
            Container(
                padding: EdgeInsets.only(right: 8),
                child: Text(_langPack.minutesBeforehand))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ConfigTimesItem(
                index: index,
              );
            },
            separatorBuilder: (context, index) => SizedBox(
                  height: 0,
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

    final LanguagePack _langPack = watch(appLanguagePackProvider.state);
    Map<String, DayData> map = watch(daysToScheduleProvider.state);
    DayData today = map['today'];

    final bool _isActive = _activeTimes.contains(_index);

    final Map<String, dynamic> dataMap = _langPack.toJson();

    bool skip = false;

    if (_index == 3) {
      skip = skipTime(today, PRAYER_TIMES[3]);
    } else if (_index == 7) {
      skip = skipTime(today, PRAYER_TIMES[7]);
    }

    return skip
        ? SizedBox()
        : Column(
            children: [
              Card(
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
                      Expanded(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                bool isGranted = await Permission
                                    .notification.status.isGranted;

                                if (isGranted) {
                                  context
                                      .read(activeTimesProvider)
                                      .toggleTime(_index);
                                } else {
                                  openAppSettings();
                                }
                              },
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
                              dataMap['${PRAYER_TIMES[_index]}'],
                              style: minor
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          color: CustomColors.mainColor,
                                          fontSize: 18)
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20),
                            ),
                          ],
                        ),
                      ),

                      DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          minWidth: 0,
                          child: DropdownButton(
                            elevation: 0,
                            hint: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 40,
                                  child: Center(
                                    child: Text(
                                      '${_notificationMinutes[_index]}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            isDense: true,
                            dropdownColor: Colors.transparent,
                            items: [
                              DropdownMenuItem<Widget>(
                                child: Consumer(
                                  builder: (context, watch, child) {
                                    List<int> mins = watch(
                                        notificationMinutesProvider.state);
                                    return Material(
                                      elevation: 2,
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      child: Stack(
                                        children: <Widget>[
                                          NumberPicker(
                                            minValue: 0,
                                            maxValue: 60,
                                            itemCount: 5,
                                            itemHeight: 35,
                                            value: mins[_index],
                                            onChanged: (c) {
                                              context
                                                  .read(
                                                      notificationMinutesProvider)
                                                  .updateTime(c, _index);
                                            },
                                            itemWidth: 40,
                                            textStyle: TextStyle(
                                              fontSize: 18,
                                              fontStyle: FontStyle.normal,
                                            ),
                                            selectedTextStyle: TextStyle(
                                              fontSize: 18,
                                              color: CustomColors.mainColor,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                            onChanged: (change) {},
                          ),
                        ),
                      ),
                      // SimpleAccountMenu(
                      //   minutes: _notificationMinutes,
                      //   index: _index,
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
            ],
          );
  }
}
