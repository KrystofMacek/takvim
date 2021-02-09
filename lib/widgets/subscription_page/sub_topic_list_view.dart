import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/subscription/sub_topic_stream_provider.dart';
import '../../providers/subscription/subs_list_provider.dart';

class SubTopicListView extends ConsumerWidget {
  const SubTopicListView({Key key, @required String mosqueId})
      : _mosqueId = mosqueId,
        super(key: key);

  final String _mosqueId;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    List<String> currentSubsList = watch(currentSubsListProvider.state);
    CurrentSubsList currentSubsListController = watch(currentSubsListProvider);

    List<String> currentMosqueSubsList = watch(currentMosqueSubs.state);
    CurrentMosqueSubs currentMosqueSubsController = watch(currentMosqueSubs);

    return watch(subTopicListStreamProvider).when(
      data: (value) {
        List<String> subtopics = [];
        value.docs.forEach((element) {
          subtopics.add(element.id);
        });

        return ListView.separated(
          shrinkWrap: true,
          itemCount: subtopics.length,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 10,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            bool subscribed = currentSubsList.contains(subtopics[index]);
            bool isMosqueSub = currentMosqueSubsList.contains(_mosqueId);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(subtopics[index]),
                Checkbox(
                  value: subscribed,
                  onChanged: (value) {
                    _subscribe(
                      context,
                      subscribed,
                      currentSubsList,
                      currentSubsListController,
                      currentMosqueSubsController,
                      subtopics,
                      index,
                      isMosqueSub,
                    );
                  },
                )
              ],
            );
          },
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Text('Error loading sub topics'),
    );
  }

  void _subscribe(
    BuildContext context,
    bool subscribed,
    List<String> currentSubsList,
    CurrentSubsList currentSubsListController,
    CurrentMosqueSubs currentMosqueSubsController,
    List<String> subtopics,
    int index,
    bool isMosqueSub,
  ) {
    // If the user is subscribed
    if (subscribed) {
      // remove from sub list
      currentSubsListController
          .removeFromSubsList(
            subtopics[index],
          )
          .whenComplete(
            () => Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Unsubscribed from ${subtopics[index]}'),
              ),
            ),
          );

      // check if he is sub to another subtopic of mosque
      bool noLongerMosqueSub = true;
      subtopics.forEach(
        (element) {
          if (currentSubsList.contains(element)) noLongerMosqueSub = false;
        },
      );
      // if he isnt remove from list
      if (noLongerMosqueSub)
        currentMosqueSubsController.removeMosqueFromSubsList(_mosqueId);
      // If the user is not subscribed
    } else {
      // Add to sub list
      currentSubsListController
          .addToSubsList(
            subtopics[index],
          )
          .whenComplete(
            () => Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Subscribed to ${subtopics[index]}'),
              ),
            ),
          );
      // if its first sub to this mosque add it to his list
      if (!isMosqueSub)
        currentMosqueSubsController.addMosqueToSubsList(_mosqueId);
    }
  }
}
