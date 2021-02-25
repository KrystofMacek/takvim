import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takvim/providers/mosque_page/mosque_detail_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/mosque_page/mosque_provider.dart';
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
                      style: CustomTextFonts.mosqueListOther.copyWith(
                          color: CustomColors.cityNameColor, fontSize: 18),
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
                        print('select');
                        if (await canLaunch(
                            'https://news.takvim.ch/mosque/${data.mosqueId}')) {
                          await launch(
                            'https://news.takvim.ch/mosque/${data.mosqueId}',
                            forceWebView: true,
                            enableJavaScript: true,
                          );
                        } else {
                          throw 'Could not launch ${data.mosqueId}';
                        }
                        // detailsId.updateSelectedMosque(data);
                        // Navigator.pushNamed(context, '/mosqueDetail');
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
                      style: CustomTextFonts.mosqueListOther.copyWith(
                          color: CustomColors.cityNameColor, fontSize: 18),
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
                        if (data.mosqueId != '1001') {
                          detailsId.updateSelectedMosque(data);
                          Navigator.pushNamed(context, '/mosqueDetail');
                        } else {
                          if (await canLaunch(
                              'https://news.takvim.ch/mosque/${data.mosqueId}')) {
                            await launch(
                              'https://news.takvim.ch/mosque/${data.mosqueId}',
                              forceSafariVC: false,
                            );
                          } else {
                            throw 'Could not launch ${data.mosqueId}';
                          }
                        }
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
