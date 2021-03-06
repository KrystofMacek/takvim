import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:MyMosq/common/styling.dart';
import '../../providers/subscription/selected_subs_item_provider.dart';
import '../../providers/subscription/subs_list_provider.dart';
import '../../data/models/subsTopic.dart';
import './stream_mosque_info.dart';

class ClosedSubsItem extends ConsumerWidget {
  const ClosedSubsItem({
    Key key,
    @required List<SubsTopic> topics,
  })  : _topics = topics,
        super(key: key);

  final List<SubsTopic> _topics;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    SelectedSubsItem _selectedSubsItemProvider = watch(selectedSubsItem);
    List<String> currentMosqueSubsList = watch(currentMosqueSubs.state);

    final SubsTopic data = _topics.first;

    return GestureDetector(
      onTap: () {
        _selectedSubsItemProvider.updateSelectedSubsItem(data.mosqueId);
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MosqueDataStream(
                mosqueId: data.mosqueId,
              ),
              Checkbox(
                value: currentMosqueSubsList.contains(data.mosqueId),
                onChanged: (value) {},
                activeColor: CustomColors.mainColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
