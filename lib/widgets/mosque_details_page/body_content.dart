import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takvim/data/models/mosque_data.dart';
import 'package:takvim/providers/mosque_page/mosque_detail_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DetailsContent extends ConsumerWidget {
  const DetailsContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final MosqueData data = watch(selectedMosqueDetail.state);
    var autoSizeGroup = AutoSizeGroup();
    final size = MediaQuery.of(context).size;
    double baseSize = size.height;

    double ratio = 375 / 667;
    final double colWidth = baseSize * ratio;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: colWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                '${data.offiziellerName}',
                style: Theme.of(context).textTheme.headline3,
                group: autoSizeGroup,
                wrapWords: false,
                maxLines: 1,
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      '${data.strasse}',
                      group: autoSizeGroup,
                      style: Theme.of(context).textTheme.headline3,
                      minFontSize: 0,
                      maxLines: 1,
                    ),
                    AutoSizeText(
                      '${data.plz} ${data.ort} ${data.kanton}',
                      group: autoSizeGroup,
                      minFontSize: 0,
                      style: Theme.of(context).textTheme.headline3,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () async {
                    String road =
                        data.strasse.replaceAll(RegExp(r"\s+\b|\b\s"), "+");
                    String url =
                        'https://www.google.com/maps/search/?api=1&query=${data.strasse}+${data.plz}+${data.ort}+${data.kanton}';
                    if (Platform.isIOS) {
                      url =
                          'http://maps.apple.com/?address=${data.ort}+${data.kanton}+$road';
                      url = url.replaceAll(RegExp(r'ë'), 'e');
                      url = url.replaceAll(RegExp(r'é'), 'e');
                      url = url.replaceAll(RegExp(r'è'), 'e');
                      url = url.replaceAll(RegExp(r'ü'), 'u');
                      url = url.replaceAll(RegExp(r'ö'), 'o');
                      url = url.replaceAll(RegExp(r'ä'), 'a');
                      url = url.replaceAll(RegExp(r'à'), 'a');
                    }
                    try {
                      await launch(url);
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    elevation: 1,
                    color: Theme.of(context).primaryColor,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: FaIcon(
                        FontAwesomeIcons.mapMarked,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 6,
                child: AutoSizeText(
                  '${data.telefon}',
                  group: autoSizeGroup,
                  style: Theme.of(context).textTheme.headline3,
                  maxLines: 1,
                  minFontSize: 0,
                ),
              ),
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () async {
                    String url = 'tel:${data.telefon}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    elevation: 1,
                    color: Theme.of(context).primaryColor,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: FaIcon(
                        FontAwesomeIcons.phone,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 35,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 6,
                child: AutoSizeText(
                  '${data.email}',
                  group: autoSizeGroup,
                  style: Theme.of(context).textTheme.headline3,
                  minFontSize: 0,
                  maxLines: 1,
                ),
              ),
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () async {
                    String url = 'mailto:${data.email}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    elevation: 1,
                    color: Theme.of(context).primaryColor,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: FaIcon(
                        FontAwesomeIcons.envelope,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 35,
          ),
          data.website.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 6,
                      child: AutoSizeText(
                        '${data.website}',
                        group: autoSizeGroup,
                        style: Theme.of(context).textTheme.headline3,
                        wrapWords: false,
                        minFontSize: 0,
                        maxLines: 1,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          String url = 'http://${data.website}';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(50),
                          elevation: 1,
                          color: Theme.of(context).primaryColor,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: FaIcon(
                              FontAwesomeIcons.link,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : SizedBox(),
          SizedBox(
            height: 35,
          ),
        ],
      ),
    );
  }
}
