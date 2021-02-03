import 'package:flutter/material.dart';
import 'package:takvim/common/styling.dart';
import 'package:takvim/data/models/dateBounds.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/date_provider.dart';

class DateSelectorRow extends StatefulWidget {
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
  _DateSelectorRowState createState() => _DateSelectorRowState();
}

class _DateSelectorRowState extends State<DateSelectorRow>
    with WidgetsBindingObserver {
  bool _resumed = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _resumed = true;
      });
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DateBounds>(
      future: widget._selectedDate.getDateBounds(),
      builder: (context, snapshot) {
        if (_resumed) {
          widget._selectedDate.onRefresh();
          _resumed = false;
        }
        if (snapshot.hasData) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Material(
                borderRadius: BorderRadius.circular(50),
                elevation: 2,
                color: Theme.of(context).primaryColor,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                  onPressed: () {
                    widget._selectedDate.subsOneDay(snapshot.data.firstDate);
                  },
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: 120),
                child: Column(
                  children: [
                    Text(
                      '${widget._selectedDate.getDateFormatted()}',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.normal, fontSize: 18),
                    ),
                    Text(
                      '${widget._selectedDate.getDayOfTheWeek(widget._appLang)}',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.normal, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(50),
                color: Theme.of(context).primaryColor,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 30,
                  ),
                  onPressed: () {
                    widget._selectedDate.addOneDay(snapshot.data.lastDate);
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
                    widget._selectedDate.subsOneDay(snapshot.data.firstDate);
                  },
                ),
              ),
              Column(
                children: [
                  Text(
                    '${widget._selectedDate.getDateFormatted()}',
                    style: CustomTextFonts.contentText,
                  ),
                  Text(
                    '${widget._selectedDate.getDayOfTheWeek(widget._appLang)}',
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
                    widget._selectedDate.addOneDay(snapshot.data.lastDate);
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
