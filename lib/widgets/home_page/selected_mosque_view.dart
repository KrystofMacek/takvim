import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MyMosq/data/models/mosque_data.dart';
import 'package:MyMosq/providers/mosque_page/mosque_provider.dart';
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
