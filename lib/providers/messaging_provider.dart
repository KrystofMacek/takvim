import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fcmProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging();
});
