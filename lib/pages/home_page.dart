import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:takvim/common/constants.dart';
import 'package:takvim/data/models/day_data.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/data/models/mosque_data.dart';
import 'package:takvim/providers/date_provider.dart';
import 'package:takvim/providers/language_provider.dart';
import 'package:takvim/providers/mosque_provider.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);
    final LanguagePack _prayerLang = watch(prayerLanguagePackProvider.state);
    final String _selectedMosque = watch(selectedMosque.state);
    final LanguagePackController _langPackController = watch(
      languagePackController,
    );
    if (_appLang == null) {
      _langPackController.updateAppLanguage();
    }
    if (_prayerLang == null) {
      _langPackController.updatePrayerLanguage();
    }

    final SelectedDate _selectedDate = watch(selectedDate);

    final MosqueController _mosqueController = watch(
      mosqueController,
    );

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PopupMenuButton<String>(
                          onSelected: _settingsMenuItemSelected,
                          icon: Icon(Icons.settings),
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
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder<MosqueData>(
                          future: _mosqueController
                              .getSelectedMosque(_selectedMosque),
                          builder: (BuildContext context,
                              AsyncSnapshot<MosqueData> snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  Text('${snapshot.data.name}'),
                                  Text(
                                      '${snapshot.data.ort} ${snapshot.data.kanton}'),
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
                    ),
                    Consumer(
                      builder: (context, watch, child) {
                        watch(selectedDate.state);

                        return Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () async {
                                      DateTime firstDate = DateTime(
                                          DateTime.now().year,
                                          DateTime.january,
                                          1);
                                      DateTime lastDate = DateTime(
                                          DateTime.now().year + 1,
                                          DateTime.january,
                                          0);
                                      final DateTime picked =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: firstDate,
                                        lastDate: lastDate,
                                      );
                                      if (picked != null) {
                                        _selectedDate
                                            .updateSelectedDate(picked);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      _selectedDate.subsOneDay();
                                    },
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                          '${_selectedDate.getDateFormatted()}'),
                                      Text(
                                          '${_selectedDate.getDayOfTheWeek(_appLang)}'),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_forward),
                                    onPressed: () {
                                      _selectedDate.addOneDay();
                                    },
                                  ),
                                ],
                              ),
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

                                    return Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: PRAYER_TIMES.length,
                                              itemBuilder: (context, index) {
                                                Map<String, String> dataMap =
                                                    _getTimeName(index,
                                                        _prayerLang, data);

                                                bool minor = false;

                                                if (index == 0 ||
                                                    index == 2 ||
                                                    index == 6) {
                                                  minor = true;
                                                }
                                                if (!minor) {
                                                  return Card(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5,
                                                              horizontal: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            '${dataMap['name']}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            '${dataMap['time']}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return Card(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5,
                                                              horizontal: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            '${dataMap['name']}',
                                                            style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          ),
                                                          Text(
                                                            '${dataMap['time']}',
                                                            style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                height: 10,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: Center(
                                                child: Text('${data.notes}')),
                                          )
                                        ],
                                      ),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                              // FutureBuilder<DayData>(
                              //   future: _mosqueController.getPrayersForDate(
                              //     _selectedDate.getDateId(),
                              //   ),
                              //   builder: (
                              //     BuildContext context,
                              //     AsyncSnapshot<DayData> snapshot,
                              //   ) {

                              //   },
                              // ),
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
