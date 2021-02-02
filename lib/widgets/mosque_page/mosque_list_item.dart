import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takvim/providers/mosque_detail_provider.dart';
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
        onTap: () {},
        child: Card(
          color: CustomColors.highlightColor,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      child: AutoSizeText(
                        '${data.name}',
                        style: CustomTextFonts.mosqueListName
                            .copyWith(color: Colors.black),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Consumer(
                  builder: (context, watch, child) {
                    SelectedMosqueDetailIdProvider detailsId =
                        watch(selectedMosqueDetail);

                    return IconButton(
                      hoverColor: Colors.transparent,
                      icon: FaIcon(
                        FontAwesomeIcons.info,
                        color: CustomColors.mainColor,
                        size: 20,
                      ),
                      onPressed: () {
                        detailsId.updateSelectedMosque(data);
                        Navigator.pushNamed(context, '/mosqueDetail');
                      },
                    );
                  },
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      child: AutoSizeText(
                        '${data.name}',
                        style: CustomTextFonts.mosqueListName
                            .copyWith(color: Colors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Consumer(
                  builder: (context, watch, child) {
                    SelectedMosqueDetailIdProvider detailsId =
                        watch(selectedMosqueDetail);

                    return IconButton(
                      hoverColor: Colors.transparent,
                      icon: FaIcon(
                        FontAwesomeIcons.info,
                        color: CustomColors.mainColor,
                        size: 20,
                      ),
                      onPressed: () {
                        detailsId.updateSelectedMosque(data);
                        Navigator.pushNamed(context, '/mosqueDetail');
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
  // if (isSelected) {
  //   return GestureDetector(
  //     onTap: () {
  //       _mosqueSelector.updateSelectedMosque(data.mosqueId);
  //     },
  //     child: Card(
  //       color: Theme.of(context).colorScheme.primaryVariant,
  //       child: Container(
  //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               '${data.ort} ${data.kanton}',
  //               style: CustomTextFonts.mosqueListOther
  //                   .copyWith(color: CustomColors.cityNameColor),
  //             ),
  //             SizedBox(
  //               height: 10,
  //             ),
  //             Text(
  //               '${data.name}',
  //               style: CustomTextFonts.mosqueListName,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // } else {
  //   return GestureDetector(
  //     onTap: () {
  //       _mosqueSelector.updateSelectedMosque(data.mosqueId);
  //     },
  //     child: Card(
  //       child: Container(
  //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               '${data.ort} ${data.kanton}',
  //               style: CustomTextFonts.mosqueListOther
  //                   .copyWith(color: CustomColors.cityNameColor),
  //             ),
  //             SizedBox(
  //               height: 10,
  //             ),
  //             Text(
  //               '${data.name}',
  //               style: CustomTextFonts.mosqueListName,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  // }
}
