import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:takvim/providers/firestore_provider.dart';
import './closed_subs_item.dart';
import './opened_subs_item.dart';
import '../../providers/subscription/selected_subs_item_provider.dart';
import '../../data/models/mosque_data.dart';
import '../../data/models/subsTopic.dart';
import 'package:collection/collection.dart';
import './single_topic_subs_item.dart';
import '../../data/models/language_pack.dart';
import '../../providers/language_page/language_provider.dart';
import './filter_field.dart';

class AvailableSubsListStream extends ConsumerWidget {
  const AvailableSubsListStream({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    String _selectedSubsItemProvider = watch(selectedSubsItem.state);
    SubsFilteringController _subsFilteringController =
        watch(subsFilteringController);
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);

    return watch(subsListStreamProvider).when(
      data: (value) {
        return Consumer(
          builder: (context, watch, child) {
            List<SubsTopic> filteredList = watch(subsFilteredMosqueList.state);

            final Map<String, List<SubsTopic>> map =
                groupBy(filteredList, (topic) => topic.mosqueId);

            final displayedTopics = map.keys.toList();

            return Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                FilterSubsriptions(
                  appLang: _appLang,
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      List<SubsTopic> topics = map['${displayedTopics[index]}'];

                      if (index == displayedTopics.length) {
                        return SizedBox(
                          height: 80,
                        );
                      }

                      bool isSingleTopic = topics.length == 1;

                      if (isSingleTopic) {
                        return SingleTopicSubsItem(
                          topic: topics.first,
                          selected: _selectedSubsItemProvider ==
                              displayedTopics[index],
                        );
                      } else {
                        return _selectedSubsItemProvider !=
                                displayedTopics[index]
                            ? ClosedSubsItem(
                                topics: topics,
                              )
                            : OpenedSubsItem(
                                topics: topics,
                              );
                      }
                    },
                    separatorBuilder: (context, index) => SizedBox(),
                    itemCount: displayedTopics.length,
                  ),
                ),
              ],
            );
          },
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text(
            'Error Loading Subscription List ${error.toString()} ${stackTrace.toString()}'),
      ),
    );
  }
}
