import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../providers/mosque_page/mosque_provider.dart';
import '../../data/models/mosque_data.dart';
import '../../common/styling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectedMosqueView extends StatelessWidget {
  const SelectedMosqueView({
    Key key,
    @required MosqueController mosqueController,
    @required String selectedMosqueController,
  })  : _mosqueController = mosqueController,
        _selectedMosqueController = selectedMosqueController,
        super(key: key);

  final MosqueController _mosqueController;
  final String _selectedMosqueController;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        // String _selectedMosque = watch(selectedMosque.state);

        return StreamBuilder<QuerySnapshot>(
          stream:
              _mosqueController.watchFirestoreMosque(_selectedMosqueController),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data.docs.first != null) {
              MosqueData selectedMosqueData =
                  MosqueData.fromJson(snapshot.data.docs.first.data());

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${selectedMosqueData.ort} ${selectedMosqueData.kanton}',
                      style: CustomTextFonts.mosqueListOther
                          .copyWith(fontSize: 18)),
                  Text(
                    '${selectedMosqueData.name}',
                    style:
                        CustomTextFonts.mosqueListName.copyWith(fontSize: 18),
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
      },
    );
  }
}

//  return FutureBuilder<MosqueData>(
//           future: _mosqueController.getSelectedMosque(_selectedMosque),
//           builder: (BuildContext context, AsyncSnapshot<MosqueData> snapshot) {
//             if (snapshot.hasData) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('${snapshot.data.ort} ${snapshot.data.kanton}',
//                       style: CustomTextFonts.mosqueListOther),
//                   Text(
//                     '${snapshot.data.name}',
//                     style: CustomTextFonts.mosqueListName,
//                   ),
//                 ],
//               );
//             } else {
//               return CircularProgressIndicator();
//             }
//           },
//         );
