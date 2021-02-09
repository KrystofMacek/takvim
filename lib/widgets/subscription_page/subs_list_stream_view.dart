import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:takvim/providers/firestore_provider.dart';
import './closed_subs_item.dart';
import './opened_subs_item.dart';
import '../../providers/subscription/selected_subs_item_provider.dart';

class AvailableSubsListStream extends ConsumerWidget {
  const AvailableSubsListStream({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    String _selectedSubsItemProvider = watch(selectedSubsItem.state);

    return watch(subsListStreamProvider).when(
      data: (value) {
        List<String> subsList = [];
        value.docs.forEach((element) {
          subsList.add(element.id);
        });

        return ListView.separated(
          itemBuilder: (context, index) {
            return _selectedSubsItemProvider != subsList[index]
                ? ClosedSubsItem(mosqueId: subsList[index])
                : OpenedSubsItem(mosqueId: subsList[index]);
          },
          separatorBuilder: (context, index) => SizedBox(
            height: 10,
          ),
          itemCount: subsList.length,
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text('Error Loading Subscription List'),
      ),
    );
  }
}
