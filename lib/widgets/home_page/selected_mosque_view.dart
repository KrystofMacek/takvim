import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takvim/common/styling.dart';
import 'package:takvim/data/models/mosque_data.dart';
import 'package:takvim/providers/mosque_provider.dart';

class SelectedMosqueView extends StatelessWidget {
  const SelectedMosqueView({
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
    return FutureBuilder<MosqueData>(
      future: _mosqueController.getSelectedMosque(_selectedMosque),
      builder: (BuildContext context, AsyncSnapshot<MosqueData> snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  '${snapshot.data.ort} ${snapshot.data.kanton}',
                  style: CustomTextFonts.appBarTextNormal,
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: '${snapshot.data.name}',
                    style: CustomTextFonts.appBarTextItalic,
                  ),
                ]),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
