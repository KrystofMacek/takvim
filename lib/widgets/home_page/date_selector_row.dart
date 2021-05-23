import 'package:flutter/material.dart';
import 'package:takvim/common/styling.dart';
import 'package:takvim/data/models/dateBounds.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/home_page/date_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
    print(state);
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
      future: widget._selectedDate.getFirestoreDateBounds(),
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
                    AutoSizeText(
                      '${widget._selectedDate.getDayOfTheWeek(widget._appLang)}',
                      maxLines: 1,
                      minFontSize: 16,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.normal, fontSize: 20),
                    ),
                    Text(
                      '${widget._selectedDate.getDateFormatted()}',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.normal, fontSize: 20),
                    ),
                    FutureBuilder<String>(
                        future: widget._selectedDate.getMoonDate(
                          widget._selectedDate.getDateId(),
                          widget._appLang,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                            );
                          } else {
                            return Text('');
                          }
                        }),
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
