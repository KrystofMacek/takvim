import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:MyMosq/common/styling.dart';
import 'package:MyMosq/data/models/dateBounds.dart';
import 'package:MyMosq/providers/home_page/date_provider.dart';

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
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(spreadRadius: .5, blurRadius: 2, color: Colors.grey),
            ],
          ),
          child: GestureDetector(
            onTap: () async {
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
            child: Icon(
              Icons.calendar_today,
              color: CustomColors.mainColor,
              size: 26,
            ),
          ),
        ),
        SizedBox(
          width: !isToday ? 18 : 0,
        ),
        !isToday
            ? Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: .5, blurRadius: 2, color: Colors.grey),
                  ],
                ),
                child: GestureDetector(
                  onTap: () async {
                    _selectedDate.updateSelectedDate(DateTime.now());
                  },
                  child: FaIcon(
                    FontAwesomeIcons.sync,
                    color: CustomColors.mainColor,
                    size: 20,
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
