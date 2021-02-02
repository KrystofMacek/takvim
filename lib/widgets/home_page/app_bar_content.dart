import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takvim/providers/mosque_provider.dart';
import 'package:takvim/widgets/home_page/home_page_widgets.dart';

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
          child: SizedBox(),
        ),
      ],
    );
  }
}
