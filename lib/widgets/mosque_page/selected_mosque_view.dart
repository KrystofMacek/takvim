import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../providers/mosque_provider.dart';
import '../../data/models/mosque_data.dart';
import '../../common/styling.dart';

class SelectedMosqueView extends StatelessWidget {
  const SelectedMosqueView({
    Key key,
    @required MosqueController mosqueController,
  })  : _mosqueController = mosqueController,
        super(key: key);

  final MosqueController _mosqueController;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        String _selectedMosque = watch(selectedMosque.state);

        return FutureBuilder<MosqueData>(
          future: _mosqueController.getSelectedMosque(_selectedMosque),
          builder: (BuildContext context, AsyncSnapshot<MosqueData> snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${snapshot.data.ort} ${snapshot.data.kanton}',
                      style: CustomTextFonts.mosqueListOther),
                  Text(
                    '${snapshot.data.name}',
                    style: CustomTextFonts.mosqueListName,
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}
