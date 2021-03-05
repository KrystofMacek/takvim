import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/mosque_page/mosque_provider.dart';
import '../../providers/common/geolocator_provider.dart';

class MosqueSettingsAppBarContent extends StatelessWidget {
  const MosqueSettingsAppBarContent({
    Key key,
    @required LanguagePack appLang,
  })  : _appLang = appLang,
        super(key: key);

  final LanguagePack _appLang;

  @override
  Widget build(BuildContext context) {
    final prefBox = Hive.box('pref');
    final bool firstOpen = prefBox.get('firstOpen');
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                !firstOpen
                    ? IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.bars,
                          size: 24,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_appLang.mosque}',
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
        ),
        Consumer(
          builder: (context, watch, child) {
            return Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.streetView,
                              color: watch(sortByDistanceToggle.state)
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () async {
                              Position position = await context
                                  .read(locationProvider)
                                  .getUsersPosition();
                              if (position != null) {
                                context.read(usersPosition).update(position);
                                context.read(sortByDistanceToggle).toggle();
                              }
                            }),
                        // watch(locationGranted.state)
                        //     ? IconButton(
                        //         icon: FaIcon(
                        //           FontAwesomeIcons.streetView,
                        //           color: watch(sortByDistanceToggle.state)
                        //               ? Theme.of(context).colorScheme.onPrimary
                        //               : Theme.of(context).iconTheme.color,
                        //         ),
                        //         onPressed: () async {
                        //           Position position = await context
                        //               .read(locationProvider)
                        //               .getUsersPosition();
                        //           if (position != null) {
                        //             context
                        //                 .read(usersPosition)
                        //                 .update(position);
                        //             context.read(sortByDistanceToggle).toggle();
                        //           }
                        //         })
                        //     : SizedBox(),
                        IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.mapMarked,
                          ),
                          onPressed: () async {
                            if (await canLaunch(
                                'https://news.takvim.ch/map?integratedView=true&languageId=${_appLang.languageId}')) {
                              await launch(
                                'https://news.takvim.ch/map?integratedView=true&languageId=${_appLang.languageId}',
                                forceSafariVC: false,
                              );
                            } else {
                              throw 'Could not launch';
                            }
                          },
                        )
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     // Switch(
                    //     //   activeTrackColor:
                    //     //       Theme.of(context).colorScheme.primaryVariant,
                    //     //   inactiveThumbColor: Colors.white,
                    //     //   activeColor: Colors.white,
                    //     //   value: watch(sortByDistanceToggle.state),
                    //     //   onChanged: (value) =>
                    //     //       context.read(sortByDistanceToggle).toggle(),
                    //     // ),
                    //     IconButton(
                    //         icon: FaIcon(FontAwesomeIcons.streetView),
                    //         onPressed: () =>
                    //             context.read(sortByDistanceToggle).toggle()),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
