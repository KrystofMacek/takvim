import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:takvim/common/constants.dart';
import 'package:takvim/common/styling.dart';
import 'package:takvim/common/utils.dart';
import 'package:takvim/data/models/day_data.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/common/notification_provider.dart';
import 'package:takvim/providers/common/permission.dart';
import 'package:takvim/providers/language_page/language_provider.dart';
import 'package:takvim/providers/notification_config_page/notification_config_providers.dart';
import 'package:takvim/widgets/subscription_page/checkbox.dart';
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
                                            maxValue: 59,
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

// class SimpleAccountMenu extends StatefulWidget {
//   final BorderRadius borderRadius;
//   final Color backgroundColor;
//   final Color iconColor;
//   final ValueChanged<int> onChange;
//   final List<int> minutes;
//   final int index;

//   const SimpleAccountMenu({
//     Key key,
//     this.borderRadius,
//     this.backgroundColor = const Color(0xFFF67C0B9),
//     this.iconColor = Colors.black,
//     this.onChange,
//     this.minutes,
//     this.index,
//   }) : super(key: key);
//   @override
//   _SimpleAccountMenuState createState() => _SimpleAccountMenuState();
// }

// class _SimpleAccountMenuState extends State<SimpleAccountMenu> {
//   GlobalKey _key;
//   bool isMenuOpen = false;
//   Offset buttonPosition;
//   Size buttonSize;
//   OverlayEntry _overlayEntry;
//   BorderRadius _borderRadius;

//   @override
//   void initState() {
//     _borderRadius = widget.borderRadius ?? BorderRadius.circular(4);
//     _key = LabeledGlobalKey("picker_${widget.index}");
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   findButton() {
//     RenderBox renderBox = _key.currentContext.findRenderObject();
//     buttonSize = renderBox.size;
//     buttonPosition = renderBox.localToGlobal(Offset.zero);
//   }

//   void closeMenu() {
//     _overlayEntry.remove();
//     isMenuOpen = !isMenuOpen;
//   }

//   void openMenu() {
//     findButton();
//     _overlayEntry = _overlayEntryBuilder();
//     Overlay.of(context).insert(_overlayEntry);
//     isMenuOpen = !isMenuOpen;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           key: _key,
//           decoration: BoxDecoration(
//             borderRadius: _borderRadius,
//           ),
//           child: GestureDetector(
//             onTap: () {
//               if (isMenuOpen) {
//                 closeMenu();
//               } else {
//                 openMenu();
//               }
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//               child: Text('${widget.minutes[widget.index]}'),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   OverlayEntry _overlayEntryBuilder() {
//     return OverlayEntry(
//       builder: (context) {
//         return Positioned(
//             top: 65.0 + (widget.index * 55),
//             left: 0,
//             // width: buttonSize.width,
//             child: Consumer(
//               builder: (context, watch, child) {
//                 List<int> mins = watch(notificationMinutesProvider.state);
//                 return Material(
//                   elevation: 2,
//                   borderRadius: BorderRadius.circular(10),
//                   color: Theme.of(context).scaffoldBackgroundColor,
//                   child: Stack(
//                     children: <Widget>[
//                       GestureDetector(
//                         onTap: () => closeMenu(),
//                         child: NumberPicker(
//                           minValue: 0,
//                           maxValue: 59,
//                           value: mins[widget.index],
//                           onChanged: (c) {
//                             context
//                                 .read(notificationMinutesProvider)
//                                 .updateTime(c, widget.index);
//                           },
//                           itemWidth: 40,
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//               },
//             ));
//       },
//     );
//   }
// }
