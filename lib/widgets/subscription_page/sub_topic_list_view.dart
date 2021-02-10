import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/subscription/sub_topic_stream_provider.dart';
import '../../providers/subscription/subs_list_provider.dart';
import '../../data/models/subsTopic.dart';
import '../../common/styling.dart';
import './checkbox.dart';

class SubTopicListView extends ConsumerWidget {
  const SubTopicListView({
    Key key,
    @required List<SubsTopic> topics,
  })  : _topics = topics,
        super(key: key);

  final List<SubsTopic> _topics;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    List<String> currentSubsList = watch(currentSubsListProvider.state);
    CurrentSubsList currentSubsListController = watch(currentSubsListProvider);

    List<String> currentMosqueSubsList = watch(currentMosqueSubs.state);
    CurrentMosqueSubs currentMosqueSubsController = watch(currentMosqueSubs);
    final SubsTopic data = _topics.first;

    return ListView.separated(
      shrinkWrap: true,
      itemCount: _topics.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 15,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        bool subscribed = currentSubsList.contains(_topics[index].topic);
        bool isMosqueSub = currentMosqueSubsList.contains(data.mosqueId);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _topics[index].label,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.black),
            ),
            Container(
              padding: EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  _subscribe(
                    context,
                    subscribed,
                    currentSubsList,
                    currentSubsListController,
                    currentMosqueSubsController,
                    _topics,
                    index,
                    isMosqueSub,
                  );
                },
                child: CustomCheckBox(
                  size: 20,
                  iconSize: 17,
                  isChecked: subscribed,
                  isDisabled: false,
                  isClickable: true,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _subscribe(
    BuildContext context,
    bool subscribed,
    List<String> currentSubsList,
    CurrentSubsList currentSubsListController,
    CurrentMosqueSubs currentMosqueSubsController,
    List<SubsTopic> subtopics,
    int index,
    bool isMosqueSub,
  ) {
    // If the user is subscribed
    if (subscribed) {
      // remove from sub list
      currentSubsListController
          .removeFromSubsList(
            subtopics[index].topic,
          )
          .whenComplete(
            () => Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Unsubscribed from ${subtopics[index].topic}'),
              ),
            ),
          );

      // check if he is sub to another subtopic of mosque
      bool noLongerMosqueSub = true;

      subtopics.forEach(
        (element) {
          if (currentSubsList.contains(element.topic))
            noLongerMosqueSub = false;
        },
      );
      // if he isnt remove from list
      if (noLongerMosqueSub)
        currentMosqueSubsController
            .removeMosqueFromSubsList(subtopics[index].mosqueId);
      // If the user is not subscribed
    } else {
      // Add to sub list
      currentSubsListController
          .addToSubsList(
            subtopics[index].topic,
          )
          .whenComplete(
            () => Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Subscribed to ${subtopics[index].topic}'),
              ),
            ),
          );
      // if its first sub to this mosque add it to his list
      if (!isMosqueSub)
        currentMosqueSubsController
            .addMosqueToSubsList(subtopics[index].mosqueId);
    }
  }
}
