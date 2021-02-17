import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/news_page/selected_mosque_news_provider.dart';
import '../../providers/firestore_provider.dart';
import '../../data/models/language_pack.dart';
import '../../providers/language_page/language_provider.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:takvim/providers/firestore_provider.dart';
import '../../widgets/home_page/app_bar.dart';
import '../../widgets/news_page/appbar_content.dart';
import '../../widgets/news_page/news_drawer.dart';
import '../../widgets/news_page/news_fab.dart';
import '../../data/models/news_post.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/subscription/subs_list_provider.dart';
import '../../common/styling.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../data/models/subsTopic.dart';

class NewsPage extends ConsumerWidget {
  const NewsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    String mosqueId = watch(selectedMosuqeNewsProvider.state);

    final LanguagePack _appLang = watch(appLanguagePackProvider.state);

    final size = MediaQuery.of(context).size;
    double baseSize = size.height;
    double ratio = 375 / 667;
    final double colWidth = baseSize * ratio;
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(
            height: 70,
            child: NewsAppBarContent(
              mosqueId: mosqueId,
            ),
          ),
          drawer: NewsDrawer(
            languagePack: _appLang,
          ),
          floatingActionButton: NewsPageFab(),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: colWidth),
                child: NewsListView(
                  mosqueId: mosqueId,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewsListView extends ConsumerWidget {
  const NewsListView({Key key, String mosqueId})
      : _mosqueId = mosqueId,
        super(key: key);

  final String _mosqueId;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    List<SubsTopic> subscribedTopics = watch(currentSubsListProvider.state);

    List<SubsTopic> subscribedMosquesTopics = subscribedTopics
        .where((element) => element.mosqueId == _mosqueId)
        .toList();

    subscribedMosquesTopics.sort((a, b) => a.label.compareTo(b.label));

    bool hideLabel = subscribedMosquesTopics.length == 1;

    return watch(mosquesNewsStreamProvider).when(
      data: (value) {
        List<NewsPost> newsPosts = [];
        value.docs.forEach((element) {
          NewsPost post = NewsPost.fromJson(element.data());
          // newsPosts.add(post);
          for (var topic in subscribedMosquesTopics) {
            if (topic.topic == post.topicId) {
              newsPosts.add(post);
            }
          }
          // if (subscribedMosquesTopics.contains(post.topicId)) {
          //   newsPosts.add(post);
          // }
        });

        newsPosts.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        newsPosts = newsPosts.reversed.toList();
        return ListView.separated(
          itemCount: newsPosts.length + 1,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox();
          },
          itemBuilder: (BuildContext context, int index) {
            if (index == newsPosts.length) {
              return SizedBox(
                height: 80,
              );
            }
            NewsPost data = newsPosts[index];
            String timestamp = DateFormat('dd.MM.yyyy').format(data.createdAt);
            return GestureDetector(
              onTap: () async {
                if (await canLaunch('http://${data.url}')) {
                  await launch('http://${data.url}');
                } else {
                  throw 'Could not launch ${data.url}';
                }
              },
              child: Card(
                // elevation: 1,
                // borderRadius: BorderRadius.circular(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$timestamp',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(fontSize: 16),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            AutoSizeText(
                              '${data.title}',
                              style: Theme.of(context).textTheme.headline3,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    !hideLabel
                        ? Flexible(
                            flex: 1,
                            // decoration: BoxDecoration(border: ),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 8),
                              decoration: BoxDecoration(
                                color: labelColoring(
                                  subscribedMosquesTopics.indexOf(
                                    subscribedMosquesTopics.firstWhere(
                                      (element) =>
                                          element.topic == data.topicId,
                                    ),
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Text('${capitalize(data.topic.split("_")[1])}'),
                                  StreamLabel(
                                      data: data,
                                      subscribedTopics: subscribedTopics),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text('Error loading news: $error'),
      ),
    );
  }

  Color labelColoring(int index) {
    switch (index) {
      case 0:
        return NewsLabelColors.color1;
        break;
      case 1:
        return NewsLabelColors.color2;
        break;
      case 2:
        return NewsLabelColors.color3;
        break;
      case 3:
        return NewsLabelColors.color4;
        break;
      default:
        return NewsLabelColors.color5;
        break;
    }
  }
}

class StreamLabel extends StatelessWidget {
  const StreamLabel({
    Key key,
    @required this.data,
    @required this.subscribedTopics,
  }) : super(key: key);

  final NewsPost data;
  final List<SubsTopic> subscribedTopics;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .doc(data.topicId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot != null && snapshot.hasData) {
            SubsTopic topic =
                SubsTopic.fromJson(snapshot.data.id, snapshot.data.data());
            return AutoSizeText(
              '${topic.label}',
              maxLines: 1,
              minFontSize: 8,
              maxFontSize: 14,
            );
          } else {
            return AutoSizeText(
              '${subscribedTopics.firstWhere((element) => element.topic == data.topicId).label}',
              maxLines: 1,
              minFontSize: 8,
              maxFontSize: 14,
            );
          }
        });
  }
}
