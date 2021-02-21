import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takvim/data/models/mosque_data.dart';
import 'package:takvim/providers/mosque_page/mosque_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    return StreamBuilder<QuerySnapshot>(
      stream: _mosqueController.watchFirestoreMosque(_selectedMosque),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data.docs.first != null) {
          MosqueData selectedMosqueData =
              MosqueData.fromJson(snapshot.data.docs.first.data());

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${selectedMosqueData.ort} ${selectedMosqueData.kanton}',
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
              Text(
                '${selectedMosqueData.name}',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
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

// FutureBuilder<MosqueData>(
//       future: _mosqueController.getSelectedMosque(_selectedMosque),
//       builder: (BuildContext context, AsyncSnapshot<MosqueData> snapshot) {
//         if (snapshot.hasData) {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: EdgeInsets.only(top: 10),
//                 child: Text(
//                   '${snapshot.data.ort} ${snapshot.data.kanton}',
//                   style: CustomTextFonts.appBarTextNormal,
//                 ),
//               ),
//               RichText(
//                 textAlign: TextAlign.center,
//                 text: TextSpan(children: [
//                   TextSpan(
//                     text: '${snapshot.data.name}',
//                     style: CustomTextFonts.appBarTextItalic,
//                   ),
//                 ]),
//               ),
//             ],
//           );
//         } else {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );
