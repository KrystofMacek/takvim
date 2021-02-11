import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takvim/common/styling.dart';
import '../../providers/subscription/selected_subs_item_provider.dart';
import './sub_topic_list_view.dart';
import '../../providers/subscription/subs_list_provider.dart';
import '../../data/models/subsTopic.dart';
import './stream_mosque_info.dart';
import './checkbox.dart';
import 'package:hive/hive.dart';

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
    bool darkTheme = Hive.box('pref').get('theme');

    List<String> currentMosqueSubsList = watch(currentMosqueSubs.state);
    SelectedSubsItem _selectedSubsItemProvider = watch(selectedSubsItem);
    final SubsTopic data = _topics.first;
    return GestureDetector(
      onTap: () {
        _selected
            ? _selectedSubsItemProvider.updateSelectedSubsItem('')
            : _selectedSubsItemProvider.updateSelectedSubsItem(data.mosqueId);
      },
      child: Card(
        color: _selected
            ? CustomColors.highlightColor
            : Theme.of(context).cardColor,
        child: Container(
          child: Column(
            children: [
              Container(
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
                        size: 25,
                        iconSize: 17,
                        isChecked:
                            currentMosqueSubsList.contains(data.mosqueId),
                        isDisabled: false,
                        isClickable: false,
                      ),
                    ),
                  ],
                ),
              ),
              if (_selected)
                SizedBox(
                  height: 10,
                ),
              if (_selected)
                Container(
                  color: darkTheme
                      ? CustomColors.highlightColorDarker
                      : CustomColors.highlightColorLighter,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: SubTopicListView(
                    topics: _topics,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
