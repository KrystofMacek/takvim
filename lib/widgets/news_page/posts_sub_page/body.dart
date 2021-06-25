import 'package:MyMosq/data/models/language_pack.dart';
import 'package:MyMosq/data/models/news_post.dart';
import 'package:MyMosq/data/models/subsTopic.dart';
import 'package:MyMosq/providers/language_page/language_provider.dart';
import 'package:MyMosq/providers/news_page/label_filter.dart';
import 'package:MyMosq/providers/subscription/subs_list_provider.dart';
import 'package:MyMosq/widgets/news_page/posts_sub_page/label_buttons_row.dart';
import 'package:MyMosq/widgets/news_page/posts_sub_page/post_list_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:MyMosq/providers/firestore_provider.dart';

class PostsSubPageBody extends ConsumerWidget {
  const PostsSubPageBody({Key key, String mosqueId})
      : _mosqueId = mosqueId,
        super(key: key);

  final String _mosqueId;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    List<SubsTopic> subscribedTopics = watch(currentSubsListProvider.state);

    List<SubsTopic> subscribedMosquesTopics = subscribedTopics
        .where((element) => element.mosqueId == _mosqueId)
        .toList();
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);

    subscribedMosquesTopics.sort((a, b) => a.label.compareTo(b.label));

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('topics')
          .where('mosqueId', isEqualTo: _mosqueId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot != null && snapshot.hasData) {
          List<SubsTopic> subTopicList = [];
          snapshot.data.docs.forEach((element) {
            subTopicList.add(SubsTopic.fromJson(element.id, element.data()));
          });

          subTopicList = subTopicList
              .where((element) => subscribedMosquesTopics.contains(element))
              .toList();

          // ORDER SUBTOPICS FROM GENERAL
          try {
            if (subTopicList.length > 1) {
              int generalIndex = subTopicList.indexWhere(
                  (element) => element.label.toLowerCase() == 'general');
              if (generalIndex != -1) {
                SubsTopic general = subTopicList.firstWhere(
                    (element) => element.label.toLowerCase() == 'general');
                subTopicList.removeAt(generalIndex);
                subTopicList.sort((a, b) => a.label.compareTo(b.label));

                List<SubsTopic> orderedSubtopicList = [
                  general,
                  ...subTopicList
                ];
                subTopicList = orderedSubtopicList;
              }
            }
          } catch (e) {
            print(e);
          }

          bool hideLabel = subTopicList.length == 1 &&
              subTopicList.first.label.toLowerCase() == 'general';

          return Consumer(
            builder: (context, watch, child) {
              HiddenTopics _hiddenTopics = watch(hiddenTopics);
              List<String> _hiddenTopicsList = watch(hiddenTopics.state);

              return watch(mosquesNewsStreamProvider).when(
                data: (value) {
                  List<NewsPost> newsPosts = [];

                  value.docs.forEach((element) {
                    NewsPost post = NewsPost.fromJson(element.data());
                    for (var topic in subscribedMosquesTopics) {
                      if (topic.topic == post.topicId) {
                        if (!newsPosts.contains(post) && !post.draft) {
                          newsPosts.add(post);
                        }
                      }
                    }
                  });

                  newsPosts.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                  newsPosts = newsPosts.reversed.toList();
                  return Column(
                    children: [
                      LabelButtonsRow(
                          subTopicList: subTopicList,
                          hiddenTopicsList: _hiddenTopicsList,
                          hiddenTopics: _hiddenTopics),
                      SizedBox(
                        height: 5,
                      ),
                      PostListView(
                        newsPosts: newsPosts,
                        subTopicList: subTopicList,
                        hiddenTopicsList: _hiddenTopicsList,
                        appLang: _appLang,
                        hideLabel: hideLabel,
                        subscribedTopics: subscribedTopics,
                      ),
                    ],
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text('Error loading news: $error'),
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
