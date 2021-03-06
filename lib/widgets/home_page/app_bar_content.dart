import 'package:MyMosq/widgets/home_page/selected_mosque_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import 'package:MyMosq/providers/language_page/language_provider.dart';
import 'package:MyMosq/providers/mosque_page/mosque_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageAppBarContent extends StatelessWidget {
  const HomePageAppBarContent({
    Key key,
    @required MosqueController mosqueController,
    @required String selectedMosque,
  })  : _mosqueController = mosqueController,
        _selectedMosque = selectedMosque,
        super(key: key);

  final MosqueController _mosqueController;
  final String _selectedMosque;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.bars,
                    size: 24,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                )
              ],
            ),
          ),
        ),
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: SelectedMosqueView(
            mosqueController: _mosqueController,
            selectedMosque: _selectedMosque,
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Consumer(
            builder: (context, watch, child) {
              LanguagePack _appLang = watch(appLanguagePackProvider.state);

              String _selectedMosqueId = watch(selectedMosque.state);

              return IconButton(
                hoverColor: Colors.transparent,
                icon: FaIcon(
                  FontAwesomeIcons.info,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () async {
                  if (await canLaunch(
                      'https://mymosq.ch/mosque/$_selectedMosqueId?integratedView=true&languageId=${_appLang.languageId}')) {
                    await launch(
                      'https://mymosq.ch/mosque/$_selectedMosqueId?integratedView=true&languageId=${_appLang.languageId}',
                      forceSafariVC: false,
                    );
                  } else {
                    throw 'Could not launch $_selectedMosque';
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
