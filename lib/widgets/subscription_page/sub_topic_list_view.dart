import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/subscription/subs_list_provider.dart';
import '../../data/models/subsTopic.dart';
import '../../common/styling.dart';
import './checkbox.dart';
import 'package:hive/hive.dart';

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
    bool darkTheme = Hive.box('pref').get('theme');
    return ListView.separated(
      shrinkWrap: true,
      itemCount: _topics.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox();
      },
      itemBuilder: (BuildContext context, int index) {
        bool subscribed = currentSubsList.contains(_topics[index].topic);
        bool isMosqueSub = currentMosqueSubsList.contains(data.mosqueId);

        return Container(
          decoration: BoxDecoration(
            borderRadius: (index == _topics.length - 1)
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  )
                : BorderRadius.circular(0),
            color: darkTheme
                ? (subscribed
                    ? CustomColors.highlightColorDarker
                    : Theme.of(context).cardColor)
                : (subscribed
                    ? CustomColors.highlightColorLighter
                    : Theme.of(context).cardColor),
          ),
          padding: EdgeInsets.only(left: 15, right: 10, top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  _topics[index].label,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        color: darkTheme ? Colors.white : Colors.black,
                        fontStyle: FontStyle.normal,
                      ),
                ),
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
                    size: 30,
                    iconSize: 20,
                    isChecked: subscribed,
                    isDisabled: false,
                    isClickable: true,
                  ),
                ),
              ),
            ],
          ),
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
      currentSubsListController.removeFromSubsList(
        subtopics[index].topic,
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
      currentSubsListController.addToSubsList(
        subtopics[index].topic,
      );
      // if its first sub to this mosque add it to his list
      if (!isMosqueSub)
        currentMosqueSubsController
            .addMosqueToSubsList(subtopics[index].mosqueId);
    }
  }
}
