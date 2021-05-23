import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/all.dart';
import '../data/models/subsTopic.dart';
import './news_page/selected_mosque_news_provider.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final subsListStreamProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  return ref
      .watch(
        firestoreProvider,
      )
      .collection(
        'topics',
      )
      .snapshots();
});

final mosquesNewsStreamProvider =
    StreamProvider.autoDispose<QuerySnapshot>((ref) {
  return ref
      .watch(
        firestoreProvider,
      )
      .collection(
        'posts',
      )
      .where('mosqueId', isEqualTo: ref.watch(selectedMosuqeNewsProvider.state))
      .snapshots();
});
