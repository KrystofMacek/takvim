import 'package:flutter_riverpod/all.dart';
import 'package:geolocator/geolocator.dart';

final locationProvider = StateNotifierProvider<LocationProvider>((ref) {
  LocationGranted _locationGranted = ref.watch(locationGranted);
  return LocationProvider(_locationGranted);
});

class LocationProvider extends StateNotifier<LocationProvider> {
  LocationProvider(this._locationGranted) : super(null);

  final LocationGranted _locationGranted;

  Future<Position> getUsersPosition() async {
    Position _currentPosition;
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return null;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      return null;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return null;
      }
    }
    _locationGranted.update(true);

    _currentPosition = await Geolocator.getCurrentPosition();

    return _currentPosition;
  }
}

final locationGranted = StateNotifierProvider<LocationGranted>((ref) {
  return LocationGranted();
});

class LocationGranted extends StateNotifier<bool> {
  LocationGranted() : super(false);

  void update(bool data) {
    state = data;
  }
}

final usersPosition = StateNotifierProvider<UsersPosition>((ref) {
  return UsersPosition();
});

class UsersPosition extends StateNotifier<Position> {
  UsersPosition() : super(null);

  void update(Position data) {
    state = data;
  }
}

// Compass

final locationFutureProvider =
    FutureProvider.autoDispose<Position>((ref) async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return null;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
    return null;
  }
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return null;
    }
  }
  ref.watch(locationGranted).update(true);

  return await Geolocator.getCurrentPosition();
});
final bearingAngleProvider = FutureProvider.autoDispose<double>((ref) async {
  double _angle = 0.0;
  ref.watch(locationFutureProvider).whenData((value) {
    final double targetLat = 21.422494;
    final double targetLong = 39.826183;
    double angle = Geolocator.bearingBetween(
        value.latitude, value.longitude, targetLat, targetLong);
    _angle = angle;
  });

  return _angle;
});
