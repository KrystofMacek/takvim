import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:MyMosq/common/styling.dart';
import '../../providers/mosque_page/mosque_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../data/models/mosque_data.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MosqueDataStream extends ConsumerWidget {
  const MosqueDataStream({Key key, String mosqueId})
      : _mosqueId = mosqueId,
        super(key: key);

  final String _mosqueId;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    MosqueController _mosqueController = watch(mosqueController);
    return StreamBuilder<QuerySnapshot>(
      stream: _mosqueController.watchFirestoreMosque(_mosqueId),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data.docs.first != null) {
          MosqueData selectedMosqueData =
              MosqueData.fromJson(snapshot.data.docs.first.data());

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${selectedMosqueData.ort} ${selectedMosqueData.kanton}',
                style: CustomTextFonts.mosqueListOther
                    .copyWith(color: CustomColors.cityNameColor, fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                child: AutoSizeText(
                  '${selectedMosqueData.name}',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontStyle: FontStyle.italic, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
