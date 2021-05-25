import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:MyMosq/providers/mosque_page/mosque_detail_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/mosque_page/mosque_provider.dart';
import '../../data/models/mosque_data.dart';
import '../../common/styling.dart';
import '../../data/models/language_pack.dart';
import '../../providers/language_page/language_provider.dart';

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
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);

    bool dist = watch(sortByDistanceToggle.state);
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
                    Row(
                      children: [
                        Text(
                          '${data.ort} ${data.kanton}',
                          style: CustomTextFonts.mosqueListOther.copyWith(
                              color: CustomColors.cityNameColor, fontSize: 18),
                        ),
                        dist
                            ? Text(
                                ' (${data.distance.toStringAsFixed(1)} km)',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      child: AutoSizeText(
                        '${data.name}',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: Colors.black, fontSize: 16),
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
                      onPressed: () async {
                        if (await canLaunch(
                            'https://mymosq.ch/mosque/${data.mosqueId}?integratedView=true&languageId=${_appLang.languageId}')) {
                          await launch(
                            'https://mymosq.ch/mosque/${data.mosqueId}?integratedView=true&languageId=${_appLang.languageId}',
                            forceSafariVC: false,
                          );
                        } else {
                          throw 'Could not launch ${data.mosqueId}';
                        }
                        // detailsId.updateSelectedMosque(data);
                        // Navigator.pushNamed(context, '/mosqueDetail');
                        // if (data.mosqueId != '1001') {
                        //   detailsId.updateSelectedMosque(data);
                        //   Navigator.pushNamed(context, '/mosqueDetail');
                        // } else {
                        //   if (await canLaunch(
                        //       'https://news.takvim.ch/mosque/${data.mosqueId}')) {
                        //     await launch(
                        //       'https://news.takvim.ch/mosque/${data.mosqueId}',
                        //       forceSafariVC: false,
                        //     );
                        //   } else {
                        //     throw 'Could not launch ${data.mosqueId}';
                        //   }
                        // }
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
          context
              .read(tempSelectedMosque)
              .updateTempSelectedMosque(data.mosqueId);
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
                    Row(
                      children: [
                        Text(
                          '${data.ort} ${data.kanton}',
                          style: CustomTextFonts.mosqueListOther.copyWith(
                              color: CustomColors.cityNameColor, fontSize: 18),
                        ),
                        dist
                            ? Text(
                                ' (${data.distance.toStringAsFixed(1)} km)',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                    ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      child: AutoSizeText(
                        '${data.name}',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontStyle: FontStyle.italic, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Consumer(
                  builder: (context, watch, child) {
                    watch(selectedMosqueDetail);

                    return IconButton(
                      hoverColor: Colors.transparent,
                      icon: FaIcon(
                        FontAwesomeIcons.info,
                        color: CustomColors.mainColor,
                        size: 20,
                      ),
                      onPressed: () async {
                        if (await canLaunch(
                            'https://mymosq.ch/mosque/${data.mosqueId}?integratedView=true&languageId=${_appLang.languageId}')) {
                          await launch(
                            'https://mymosq.ch/mosque/${data.mosqueId}?integratedView=true&languageId=${_appLang.languageId}',
                            forceSafariVC: false,
                          );
                        } else {
                          throw 'Could not launch ${data.mosqueId}';
                        }
                        // detailsId.updateSelectedMosque(data);
                        // Navigator.pushNamed(context, '/mosqueDetail');
                        // if (data.mosqueId != '1001') {
                        //   detailsId.updateSelectedMosque(data);
                        //   Navigator.pushNamed(context, '/mosqueDetail');
                        // } else {
                        //   if (await canLaunch(
                        //       'https://news.takvim.ch/mosque/${data.mosqueId}')) {
                        //     await launch(
                        //       'https://news.takvim.ch/mosque/${data.mosqueId}',
                        //       forceSafariVC: false,
                        //     );
                        //   } else {
                        //     throw 'Could not launch ${data.mosqueId}';
                        //   }
                        // }
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
}
