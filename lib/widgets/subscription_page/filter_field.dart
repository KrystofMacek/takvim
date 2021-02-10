import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../providers/mosque_page/mosque_provider.dart';
import '../../data/models/language_pack.dart';
import '../../common/styling.dart';
import '../../providers/firestore_provider.dart';

class FilterSubsriptions extends StatelessWidget {
  const FilterSubsriptions({
    Key key,
    @required LanguagePack appLang,
  })  : _appLang = appLang,
        super(key: key);

  final LanguagePack _appLang;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        SubsFilteringController _subsFilteringController =
            watch(subsFilteringController);
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          child: TextField(
            style: CustomTextFonts.mosqueListOther,
            cursorColor: CustomColors.mainColor,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: new BorderSide(
                color: CustomColors.mainColor,
              )),
              filled: true,
              hintText: '${_appLang.search}',
            ),
            onChanged: (value) {
              _subsFilteringController.filterMosqueList(value);
            },
          ),
        );
      },
    );
  }
}
