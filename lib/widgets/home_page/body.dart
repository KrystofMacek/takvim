import 'package:MyMosq/widgets/home_page/daily_data_view.dart';
import 'package:MyMosq/widgets/home_page/date_picker.dart';
import 'package:MyMosq/widgets/home_page/date_selector_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import 'package:MyMosq/providers/home_page/date_provider.dart';
import 'package:MyMosq/providers/mosque_page/mosque_provider.dart';

class HomePageBodyContent extends StatelessWidget {
  const HomePageBodyContent({
    Key key,
    @required SelectedDate selectedDate,
    @required LanguagePack appLang,
    @required MosqueController mosqueController,
  })  : _selectedDate = selectedDate,
        _appLang = appLang,
        _mosqueController = mosqueController,
        super(key: key);

  final SelectedDate _selectedDate;
  final LanguagePack _appLang;
  final MosqueController _mosqueController;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        watch(selectedDate.state);
        return Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CalendarDayPicker(
                  selectedDate: _selectedDate,
                ),
                SizedBox(
                  height: 12,
                ),
                DateSelectorRow(
                  selectedDate: _selectedDate,
                  appLang: _appLang,
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Container(
                    child: DailyDataView(
                      mosqueController: _mosqueController,
                      selectedDate: _selectedDate,
                      appLang: _appLang,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
