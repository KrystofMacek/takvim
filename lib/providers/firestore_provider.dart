import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/all.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});
