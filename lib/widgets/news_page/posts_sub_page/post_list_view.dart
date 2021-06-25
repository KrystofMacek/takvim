import 'package:MyMosq/data/models/language_pack.dart';
import 'package:MyMosq/data/models/news_post.dart';
import 'package:MyMosq/data/models/subsTopic.dart';
import 'package:MyMosq/widgets/news_page/posts_sub_page/post_list_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostListView extends StatelessWidget {
  const PostListView({
    Key key,
    @required this.newsPosts,
    @required this.subTopicList,
    @required List<String> hiddenTopicsList,
    @required LanguagePack appLang,
    @required this.hideLabel,
    @required this.subscribedTopics,
  })  : _hiddenTopicsList = hiddenTopicsList,
        _appLang = appLang,
        super(key: key);

  final List<NewsPost> newsPosts;
  final List<SubsTopic> subTopicList;
  final List<String> _hiddenTopicsList;
  final LanguagePack _appLang;
  final bool hideLabel;
  final List<SubsTopic> subscribedTopics;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
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
          if (subTopicList.length > 1 &&
              _hiddenTopicsList.contains(newsPosts[index].topicId)) {
            return SizedBox();
          }
          NewsPost data = newsPosts[index];
          String timestamp = DateFormat('dd.MM.yyyy').format(data.createdAt);
          return PostListItem(
            data: data,
            appLang: _appLang,
            timestamp: timestamp,
            hideLabel: hideLabel,
            subTopicList: subTopicList,
            subscribedTopics: subscribedTopics,
          );
        },
      ),
    );
  }
}
