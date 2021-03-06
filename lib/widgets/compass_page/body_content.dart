import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/all.dart';
import '../../providers/common/geolocator_provider.dart';
import '../../providers/language_page/language_provider.dart';
import '../../common/styling.dart';
import '../../data/models/language_pack.dart';

class CompassBodyContent extends StatefulWidget {
  CompassBodyContent({Key key}) : super(key: key);

  @override
  _CompassBodyContentState createState() => _CompassBodyContentState();
}

class _CompassBodyContentState extends State<CompassBodyContent> {
  final double targetLat = 21.422494;
  final double targetLong = 39.826183;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Column(
        children: <Widget>[
          Expanded(child: _buildCompass()),
        ],
      );
    });
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.hasError) {
          return Consumer(
            builder: (context, watch, child) {
              final LanguagePack _appLang =
                  watch(appLanguagePackProvider.state);
              return Center(
                child: Text("${_appLang.errorSensor}"),
              );
            },
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        double direction = snapshot.data.heading;
        // double direction = 144;
        return Consumer(
          builder: (context, watch, child) {
            final LanguagePack _appLang = watch(appLanguagePackProvider.state);
            return watch(bearingAngleProvider).when(
              data: (bearingAngle) {
                double angl = (((direction + (360 - bearingAngle)) ?? 0) *
                    (math.pi / 180) *
                    -1);

                bool aligned = (bearingAngle - direction) < 5 &&
                    (bearingAngle - direction) > -5;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Text(
                        "${direction.round()} °N",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: !aligned
                            ? Theme.of(context).dividerColor
                            : CustomColors.highlightColor,
                      ),
                      child: Transform.rotate(
                        angle: angl,
                        child: Container(
                          color: Colors.transparent,
                          child: Image.asset(
                            'assets/images/arrow.png',
                            height: 300,
                            width: 300,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: Text(
                        "${_appLang.compass}: ${bearingAngle.round()} °N",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => CircularProgressIndicator(),
              error: (error, stackTrace) {
                return Text('$error');
              },
            );
          },
        );
      },
    );
  }
}
