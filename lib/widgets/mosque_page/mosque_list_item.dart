import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../providers/mosque_provider.dart';
import '../../data/models/mosque_data.dart';
import '../../common/styling.dart';

class MosqueItem extends ConsumerWidget {
  const MosqueItem({
    Key key,
    @required this.data,
    @required this.isSelected,
  }) : super(key: key);

  final MosqueData data;
  final bool isSelected;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    SelectedMosque _mosqueSelector = watch(selectedMosque);
    if (isSelected) {
      return GestureDetector(
        onTap: () {
          _mosqueSelector.updateSelectedMosque(data.mosqueId);
        },
        child: Card(
          color: Colors.blue[100],
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data.ort} ${data.kanton}',
                  style: CustomTextFonts.mosqueListOther
                      .copyWith(color: CustomColors.cityNameColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${data.name}',
                  style: CustomTextFonts.mosqueListName,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          _mosqueSelector.updateSelectedMosque(data.mosqueId);
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data.ort} ${data.kanton}',
                  style: CustomTextFonts.mosqueListOther
                      .copyWith(color: CustomColors.cityNameColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${data.name}',
                  style: CustomTextFonts.mosqueListName,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
