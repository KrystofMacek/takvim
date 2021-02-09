import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/all.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final subsListStreamProvider = StreamProvider.autoDispose<QuerySnapshot>(
  (ref) => ref
      .watch(
        firestoreProvider,
      )
      .collection(
        'subscriptions2',
      )
      .snapshots(),
);
