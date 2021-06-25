import 'package:MyMosq/widgets/home_page/body.dart';
import 'package:flutter/material.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import 'package:MyMosq/providers/home_page/date_provider.dart';
import 'package:MyMosq/providers/language_page/language_provider.dart';
import 'package:MyMosq/providers/mosque_page/mosque_provider.dart';

class HomePageBodyWrapper extends StatelessWidget {
  const HomePageBodyWrapper({
    Key key,
    @required LanguagePackController langPackController,
    @required this.colWidth,
    @required SelectedDate selectedDate,
    @required LanguagePack appLang,
    @required MosqueController mosqueController,
  })  : _langPackController = langPackController,
        _selectedDate = selectedDate,
        _appLang = appLang,
        _mosqueController = mosqueController,
        super(key: key);

  final LanguagePackController _langPackController;
  final double colWidth;
  final SelectedDate _selectedDate;
  final LanguagePack _appLang;
  final MosqueController _mosqueController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 15),
      child: Center(
        child: FutureBuilder(
          future: _langPackController.getAppLangPack(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: colWidth),
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            HomePageBodyContent(
                              selectedDate: _selectedDate,
                              appLang: _appLang,
                              mosqueController: _mosqueController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
