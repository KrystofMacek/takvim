import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:takvim/common/constants.dart';
import 'package:takvim/data/models/dateBounds.dart';
import 'package:takvim/data/models/day_data.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/data/models/mosque_data.dart';
import 'package:takvim/providers/date_provider.dart';
import 'package:takvim/providers/language_provider.dart';
import 'package:takvim/providers/mosque_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import '../common/styling.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);
    // final LanguagePack _prayerLang = watch(prayerLanguagePackProvider.state);
    final String _selectedMosque = watch(selectedMosque.state);
    final LanguagePackController _langPackController = watch(
      languagePackController,
    );
    if (_appLang == null) {
      _langPackController.updateAppLanguage();
    }
    // if (_prayerLang == null) {
    //   _langPackController.updatePrayerLanguage();
    // }

    final SelectedDate _selectedDate = watch(selectedDate);

    final MosqueController _mosqueController = watch(
      mosqueController,
    );

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Center(
          child: FutureBuilder(
            future: _langPackController.getPacks(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SettingBtnView(appLang: _appLang),
                    SelectedMosqueView(
                        mosqueController: _mosqueController,
                        selectedMosque: _selectedMosque),
                    Consumer(
                      builder: (context, watch, child) {
                        watch(selectedDate.state);

                        return Expanded(
                          child: Column(
                            children: [
                              CalendarDayPicker(selectedDate: _selectedDate),
                              DateSelectorRow(
                                  selectedDate: _selectedDate,
                                  appLang: _appLang),
                              StreamBuilder<Event>(
                                stream: _mosqueController.getPrayersForDate(
                                  _selectedDate.getDateId(),
                                ),
                                builder: (BuildContext context,
                                    AsyncSnapshot<Event> snapshot) {
                                  if (snapshot.hasData &&
                                      !snapshot.hasError &&
                                      snapshot.data.snapshot.value != null) {
                                    DayData data = DayData.fromFirebase(
                                        snapshot.data.snapshot.value);

                                    String isha =
                                        data.isha.replaceFirst(":", "");
                                    String ishaTime =
                                        data.ishaTime.replaceFirst(":", "");
                                    print('replacing : $isha $ishaTime');

                                    bool skipIshaTime = false;

                                    if (int.tryParse(ishaTime) >=
                                        int.tryParse(isha)) {
                                      print('swap = true');
                                      skipIshaTime = true;
                                    }

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: PRAYER_TIMES.length,
                                          itemBuilder: (context, index) {
                                            Map<String, String> dataMap =
                                                _getTimeName(
                                                    index, _appLang, data);

                                            bool minor = false;

                                            if (index == 0 ||
                                                index == 2 ||
                                                index == 6) {
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
                                          height: 10,
                                        ),
                                        SingleChildScrollView(
                                          child: Text(
                                            '${data.notes}',
                                            style: CustomTextFonts
                                                .mosqueListName
                                                .copyWith(
                                                    color: Colors.green[400]),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
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
      return Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${dataMap['name']}',
                style: CustomTextFonts.mosqueListName,
              ),
              Text(
                '${dataMap['time']}',
                style: CustomTextFonts.mosqueListName,
              ),
            ],
          ),
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
                style: CustomTextFonts.contentTextBold,
              ),
              Text(
                '${dataMap['time']}',
                style: CustomTextFonts.contentTextBold,
              ),
            ],
          ),
        ),
      );
    }
  }
}

class DateSelectorRow extends StatelessWidget {
  const DateSelectorRow({
    Key key,
    @required SelectedDate selectedDate,
    @required LanguagePack appLang,
  })  : _selectedDate = selectedDate,
        _appLang = appLang,
        super(key: key);

  final SelectedDate _selectedDate;
  final LanguagePack _appLang;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Material(
          borderRadius: BorderRadius.circular(50),
          elevation: 2,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.blue,
            ),
            onPressed: () {
              _selectedDate.subsOneDay();
            },
          ),
        ),
        Column(
          children: [
            Text(
              '${_selectedDate.getDateFormatted()}',
              style: CustomTextFonts.contentText,
            ),
            Text(
              '${_selectedDate.getDayOfTheWeek(_appLang)}',
              style: CustomTextFonts.contentText,
            ),
          ],
        ),
        Material(
          elevation: 2,
          child: IconButton(
            icon: Icon(
              Icons.arrow_forward,
              size: 30,
              color: Colors.blue,
            ),
            onPressed: () {
              _selectedDate.addOneDay();
            },
          ),
        ),
      ],
    );
  }
}

class CalendarDayPicker extends StatelessWidget {
  const CalendarDayPicker({
    Key key,
    @required SelectedDate selectedDate,
  })  : _selectedDate = selectedDate,
        super(key: key);

  final SelectedDate _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.calendar_today,
            color: Colors.blue,
            size: 30,
          ),
          onPressed: () async {
            DateBounds bounds = await _selectedDate.getDateBounds();

            final DateTime picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: bounds.firstDate,
              lastDate: bounds.lastDate,
            );
            if (picked != null) {
              _selectedDate.updateSelectedDate(picked);
            }
          },
        ),
        IconButton(
          icon: Icon(
            Icons.refresh,
            size: 30,
          ),
          color: Colors.blue,
          onPressed: () async {
            _selectedDate.updateSelectedDate(DateTime.now());
          },
        ),
      ],
    );
  }
}

class SelectedMosqueView extends StatelessWidget {
  const SelectedMosqueView({
    Key key,
    @required MosqueController mosqueController,
    @required String selectedMosque,
  })  : _mosqueController = mosqueController,
        _selectedMosque = selectedMosque,
        super(key: key);

  final MosqueController _mosqueController;
  final String _selectedMosque;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<MosqueData>(
          future: _mosqueController.getSelectedMosque(_selectedMosque),
          builder: (BuildContext context, AsyncSnapshot<MosqueData> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text(
                    '${snapshot.data.name}',
                    style: CustomTextFonts.contentTextItalic,
                  ),
                  Text(
                    '${snapshot.data.ort} ${snapshot.data.kanton}',
                    style: CustomTextFonts.contentText,
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }
}

class SettingBtnView extends StatelessWidget {
  const SettingBtnView({
    Key key,
    @required LanguagePack appLang,
  })  : _appLang = appLang,
        super(key: key);

  final LanguagePack _appLang;

  @override
  Widget build(BuildContext context) {
    void _settingsMenuItemSelected(String choice) {
      switch (choice) {
        case LANG_SETTINGS:
          Navigator.pushNamed(context, '/lang');
          break;
        case MOSQUE_SETTINGS:
          Navigator.pushNamed(context, '/mosque');
          break;
        default:
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PopupMenuButton<String>(
          onSelected: _settingsMenuItemSelected,
          icon: Icon(
            Icons.settings,
            color: Colors.blue,
          ),
          itemBuilder: (context) {
            return [LANG_SETTINGS, MOSQUE_SETTINGS].map(
              (String choice) {
                switch (choice) {
                  case LANG_SETTINGS:
                    return PopupMenuItem(
                      value: choice,
                      child: Text('${_appLang.language}'),
                    );
                    break;
                  case MOSQUE_SETTINGS:
                    return PopupMenuItem(
                      value: choice,
                      child: Text('${_appLang.mosque}'),
                    );
                    break;
                  default:
                }
              },
            ).toList();
          },
        ),
      ],
    );
  }
}
