import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takvim/common/styling.dart';
import '../../providers/subscription/selected_subs_item_provider.dart';
import '../../providers/subscription/subs_list_provider.dart';
import '../../data/models/subsTopic.dart';

class SingleTopicSubsItem extends ConsumerWidget {
  const SingleTopicSubsItem({
    Key key,
    @required SubsTopic topic,
    @required bool selected,
  })  : _topic = topic,
        _selected = selected,
        super(key: key);

  final SubsTopic _topic;
  final bool _selected;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    SelectedSubsItem _selectedSubsItemProvider = watch(selectedSubsItem);

    List<String> currentSubsList = watch(currentSubsListProvider.state);
    CurrentSubsList currentSubsListController = watch(currentSubsListProvider);

    bool subscribed = currentSubsList.contains(_topic.topic);

    return GestureDetector(
      onTap: () {
        _selected
            ? _selectedSubsItemProvider.updateSelectedSubsItem('')
            : _selectedSubsItemProvider.updateSelectedSubsItem(_topic.mosqueId);
      },
      child: Card(
        color: _selected
            ? CustomColors.highlightColor
            : Theme.of(context).cardColor,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_topic.mosqueName} - ${_topic.label}',
                    style: CustomTextFonts.mosqueListOther.copyWith(
                        color: CustomColors.cityNameColor, fontSize: 18),
                  ),
                ],
              ),
              Checkbox(
                value: subscribed,
                activeColor: CustomColors.mainColor,
                onChanged: (value) {
                  if (subscribed) {
                    // remove from sub list
                    currentSubsListController
                        .removeFromSubsList(
                          _topic.topic,
                        )
                        .whenComplete(
                          () => Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Unsubscribed from ${_topic.topic}'),
                            ),
                          ),
                        );
                  } else {
                    currentSubsListController
                        .addToSubsList(
                          _topic.topic,
                        )
                        .whenComplete(
                          () => Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Subscribed to ${_topic.topic}'),
                            ),
                          ),
                        );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
