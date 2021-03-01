import 'dart:math' as math;
import 'package:compasstools/compasstools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

class CompassBodyContent extends StatefulWidget {
  CompassBodyContent({Key key}) : super(key: key);

  @override
  _CompassBodyContentState createState() => _CompassBodyContentState();
}

class _CompassBodyContentState extends State<CompassBodyContent> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return FutureBuilder(
        future: checkDeviceSensors(),
        builder: (_, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          if (snapshot.hasError)
            return Center(
              child: Text("Error: ${snapshot.error.toString()}"),
            );

          // if (snapshot.data) return QiblahCompassWidget();
          return Container(
            child: Text('No'),
          );
        },
      );
    });
  }

  Future<void> checkDeviceSensors() async {
    String sensorType;
    int haveSensor;

    try {
      haveSensor = await Compasstools.checkSensors;
      print('haveSensor: $haveSensor');

      switch (haveSensor) {
        case 0:
          {
            sensorType = "No sensors for compass!";
          }
          break;

        case 1:
          {
            sensorType = "Accelerometer + Magnetometer!";
          }
          break;

        case 2:
          {
            sensorType = "Gyroscope!";
          }
          break;

        default:
          {
            sensorType = "Error!";
          }
          break;
      }
    } on Exception {}
    if (!mounted) return;

    print(sensorType);
  }

  Widget _buildCompass() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // might need to accound for padding on iphones
    //var padding = MediaQuery.of(context).padding;
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        double direction = snapshot.data.heading;

        // if direction is null, then device does not support this sensor
        // show error message
        if (direction == null)
          return Center(
            child: Text("Device does not have sensors !"),
          );

        int ang = (direction.round());
        return Stack(
          children: [
            Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEBEBEB),
              ),
              child: Transform.rotate(
                angle: ((direction ?? 0) * (math.pi / 180) * -1),
                child: Container(
                    color: Colors.red,
                    child: SizedBox(
                      height: 10,
                      width: 15,
                    )),
              ),
            ),
            Center(
              child: Text(
                "$ang",
                style: TextStyle(
                  color: Color(0xFFEBEBEB),
                  fontSize: 56,
                ),
              ),
            ),
            Positioned(
              // center of the screen - half the width of the rectangle
              left: (width / 2) - ((width / 80) / 2),
              // height - width is the non compass vertical space, half of that
              top: (height - width) / 2,
              child: SizedBox(
                width: width / 80,
                height: width / 10,
                child: Container(
                  //color: HSLColor.fromAHSL(0.85, 0, 0, 0.05).toColor(),
                  color: Color(0xBBEBEBEB),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class QiblahCompassWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();

        final qiblahDirection = snapshot.data;

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: ((qiblahDirection.direction ?? 0) * (math.pi / 180) * -1),
              child: Container(
                  color: Colors.green,
                  child: SizedBox(
                    height: 10,
                    width: 20,
                  )),
            ),
            Transform.rotate(
              angle: ((qiblahDirection.qiblah ?? 0) * (math.pi / 180) * -1),
              alignment: Alignment.center,
              child: Container(
                  color: Colors.red,
                  child: SizedBox(
                    height: 10,
                    width: 20,
                  )),
            ),
            Positioned(
              bottom: 8,
              child: Text("${qiblahDirection.offset.toStringAsFixed(3)}°"),
            )
          ],
        );
      },
    );
  }
}
