import 'package:flutter_riverpod/all.dart';
import 'package:geolocator/geolocator.dart';

final locationProvider = FutureProvider.autoDispose<Position>((ref) async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  return await Geolocator.getCurrentPosition();
});

final bearingAngleProvider = FutureProvider.autoDispose<double>((ref) async {
  double _angle = 0.0;
  ref.watch(locationProvider).whenData((value) {
    final double targetLat = 21.422494;
    final double targetLong = 39.826183;

    double angle = Geolocator.bearingBetween(
        value.latitude, value.longitude, targetLat, targetLong);
    _angle = angle;
  });

  return _angle;
});

// final distanceProvider =
//     FutureProvider.autoDispose.family<double, Position>((ref) {
//   return Future.value(5);
// });
