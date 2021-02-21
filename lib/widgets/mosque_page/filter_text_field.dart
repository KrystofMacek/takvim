import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../providers/mosque_page/mosque_provider.dart';
import '../../data/models/language_pack.dart';
import '../../common/styling.dart';
import '../../providers/common/filter_text_provider.dart';

class FilterMosqueInput extends StatelessWidget {
  const FilterMosqueInput({
    Key key,
    @required LanguagePack appLang,
    @required MosqueController mosqueController,
  })  : _appLang = appLang,
        _mosqueController = mosqueController,
        super(key: key);

  final LanguagePack _appLang;
  final MosqueController _mosqueController;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
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
              hintText: '${_appLang.search}...',
            ),
            onChanged: (value) {
              _mosqueController.filterMosqueList(value);
              context.read(filterTextField).updateText(value);
            },
          ),
        );
      },
    );
  }
}
