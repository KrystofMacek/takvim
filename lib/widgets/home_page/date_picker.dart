import 'package:MyMosq/providers/home_page/pager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:MyMosq/common/styling.dart';
import 'package:MyMosq/data/models/dateBounds.dart';
import 'package:MyMosq/providers/home_page/date_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarDayPicker extends StatelessWidget {
  const CalendarDayPicker({
    Key key,
    @required SelectedDate selectedDate,
  })  : _selectedDate = selectedDate,
        super(key: key);

  final SelectedDate _selectedDate;

  @override
  Widget build(BuildContext context) {
    bool isToday = (DateTime.now().day == _selectedDate.state.day &&
        DateTime.now().month == _selectedDate.state.month &&
        DateTime.now().year == _selectedDate.state.year);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(10),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.calendar_today,
              color: CustomColors.mainColor,
              size: 40,
            ),
            onPressed: () async {
              DateBounds bounds = await _selectedDate.getFirestoreDateBounds();

              final DateTime picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate.state,
                firstDate: bounds.firstDate,
                lastDate: bounds.lastDate,
              );
              if (picked != null) {
                _selectedDate.updateSelectedDate(picked);
              }
            },
          ),
        ),
        SizedBox(
          width: !isToday ? 10 : 0,
        ),
        !isToday
            ? Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(10),
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.sync,
                    color: CustomColors.mainColor,
                    size: 24,
                  ),
                  onPressed: () async {
                    _selectedDate.updateSelectedDate(DateTime.now());
                  },
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
