import 'package:flutter/material.dart';
import 'package:takvim/common/styling.dart';
import 'package:takvim/data/models/dateBounds.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/date_provider.dart';

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
    return FutureBuilder<DateBounds>(
        future: _selectedDate.getDateBounds(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(50),
                  elevation: 2,
                  color: CustomColors.mainColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _selectedDate.subsOneDay(snapshot.data.firstDate);
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
                  borderRadius: BorderRadius.circular(50),
                  color: CustomColors.mainColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _selectedDate.addOneDay(snapshot.data.lastDate);
                    },
                  ),
                ),
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(50),
                  elevation: 2,
                  color: Colors.grey,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _selectedDate.subsOneDay(snapshot.data.firstDate);
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
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _selectedDate.addOneDay(snapshot.data.lastDate);
                    },
                  ),
                ),
              ],
            );
          }
        });
  }
}
