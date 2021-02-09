import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firestore_provider.dart';
import 'selected_subs_item_provider.dart';

final subTopicListStreamProvider = StreamProvider.autoDispose<QuerySnapshot>(
  (ref) => ref
      .watch(
        firestoreProvider,
      )
      .collection(
        'subscriptions2',
      )
      .doc(
        ref.watch(selectedSubsItem.state),
      )
      .collection('topics')
      .snapshots(),
);
