import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takvim/common/styling.dart';
import '../../providers/subscription/selected_subs_item_provider.dart';
import './sub_topic_list_view.dart';
import '../../providers/subscription/subs_list_provider.dart';
import '../../data/models/subsTopic.dart';
import './stream_mosque_info.dart';
import './checkbox.dart';

class OpenedSubsItem extends ConsumerWidget {
  const OpenedSubsItem({
    Key key,
    @required List<SubsTopic> topics,
    @required bool selected,
  })  : _topics = topics,
        _selected = selected,
        super(key: key);

  final List<SubsTopic> _topics;
  final bool _selected;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    List<String> currentMosqueSubsList = watch(currentMosqueSubs.state);
    SelectedSubsItem _selectedSubsItemProvider = watch(selectedSubsItem);
    final SubsTopic data = _topics.first;
    return Card(
      child: GestureDetector(
        onTap: () {
          _selected
              ? _selectedSubsItemProvider.updateSelectedSubsItem('')
              : _selectedSubsItemProvider.updateSelectedSubsItem(data.mosqueId);
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    (currentMosqueSubsList.contains(data.mosqueId) && _selected)
                        ? BorderRadius.only(
                            topRight: Radius.circular(5),
                            topLeft: Radius.circular(5),
                          )
                        : BorderRadius.circular(5),
                color: currentMosqueSubsList.contains(data.mosqueId)
                    ? CustomColors.highlightColor
                    : Theme.of(context).cardColor,
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MosqueDataStream(
                    mosqueId: data.mosqueId,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: CustomCheckBox(
                      size: 30,
                      iconSize: 20,
                      isChecked: currentMosqueSubsList.contains(data.mosqueId),
                      isDisabled: false,
                      isClickable: false,
                    ),
                  ),
                ],
              ),
            ),
            if (_selected)
              SubTopicListView(
                topics: _topics,
              ),
          ],
        ),
      ),
    );
  }
}
