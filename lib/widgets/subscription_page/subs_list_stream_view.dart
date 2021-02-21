import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:takvim/providers/firestore_provider.dart';
import './opened_subs_item.dart';
import '../../providers/subscription/selected_subs_item_provider.dart';
import '../../data/models/subsTopic.dart';
import 'package:collection/collection.dart';
import './single_topic_subs_item.dart';
import '../../data/models/language_pack.dart';
import '../../providers/language_page/language_provider.dart';
import '../../providers/mosque_page/mosque_provider.dart';
import '../../data/models/mosque_data.dart';
import '../../widgets/mosque_page/filter_text_field.dart';
import './unsubscribable_item.dart';

class AvailableSubsListStream extends ConsumerWidget {
  const AvailableSubsListStream({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);
    final MosqueController _mosqueController = watch(mosqueController);

    return Column(
      children: [
        SizedBox(
          height: 7,
        ),
        FilterMosqueInput(
            appLang: _appLang, mosqueController: _mosqueController),
        SizedBox(
          height: 5,
        ),
        Expanded(
          child: StreamBuilder<List<MosqueData>>(
            stream: _mosqueController.watchSubscribableFirestoreMosques(),
            initialData: [],
            builder: (BuildContext context,
                AsyncSnapshot<List<MosqueData>> snapshot) {
              if (snapshot.hasData) {
                return Consumer(
                  builder: (context, watch, child) {
                    // SUBSCRIPTION
                    return watch(subsListStreamProvider).when(
                      data: (value) {
                        // List<SubsTopic> filteredSubsTopicList =
                        //     watch(subsFilteredMosqueList.state);

                        List<SubsTopic> subsTopics = [];
                        value.docs.forEach((element) {
                          subsTopics.add(
                              SubsTopic.fromJson(element.id, element.data()));
                        });

                        final Map<String, List<SubsTopic>> subsMap =
                            groupBy(subsTopics, (topic) => topic.mosqueId);

                        final subscibableMosques = subsMap.keys.toList();
                        List<MosqueData> filteredList =
                            watch(filteredMosqueList.state);
                        String _selectedSubsItemProvider =
                            watch(selectedSubsItem.state);
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  if (index == filteredList.length) {
                                    return SizedBox(
                                      height: 80,
                                    );
                                  }

                                  MosqueData mosqueData = filteredList[index];
                                  bool isSubscribable = subscibableMosques
                                      .contains(mosqueData.mosqueId);

                                  if (index == filteredList.length) {
                                    return SizedBox(
                                      height: 80,
                                    );
                                  }

                                  if (!isSubscribable) {
                                    return UnsubscribableTopicItem(
                                      mosqueData: mosqueData,
                                      selected: _selectedSubsItemProvider ==
                                          mosqueData.mosqueId,
                                    );
                                  }

                                  bool isSingleTopic =
                                      subsMap[mosqueData.mosqueId].length == 1;

                                  if (isSingleTopic) {
                                    SubsTopic topic =
                                        subsMap['${mosqueData.mosqueId}'].first;
                                    return SingleTopicSubsItem(
                                      mosqueData: mosqueData,
                                      topic: topic,
                                      selected: _selectedSubsItemProvider ==
                                          mosqueData.mosqueId,
                                    );
                                  } else {
                                    List<SubsTopic> topics =
                                        subsMap['${mosqueData.mosqueId}'];
                                    return OpenedSubsItem(
                                      selected: _selectedSubsItemProvider ==
                                          mosqueData.mosqueId,
                                      topics: topics,
                                    );
                                  }
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(),
                                itemCount: filteredList.length + 1,
                              ),
                            ),
                          ],
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
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ],
    );
  }
}
