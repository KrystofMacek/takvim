import 'package:flutter/material.dart';
import 'package:takvim/common/styling.dart';
import 'package:takvim/data/models/dateBounds.dart';
import 'package:takvim/providers/date_provider.dart';

class CalendarDayPicker extends StatelessWidget {
  const CalendarDayPicker({
    Key key,
    @required SelectedDate selectedDate,
  })  : _selectedDate = selectedDate,
        super(key: key);

  final SelectedDate _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Material(
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
    );
  }
}
