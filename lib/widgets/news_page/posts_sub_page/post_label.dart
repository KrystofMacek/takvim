import 'package:MyMosq/data/models/news_post.dart';
import 'package:MyMosq/data/models/subsTopic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PostLabel extends StatelessWidget {
  const PostLabel({
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
              style: TextStyle(color: Colors.black),
              maxLines: 1,
              minFontSize: 8,
              maxFontSize: 14,
            );
          } else {
            return AutoSizeText(
              '${subscribedTopics.firstWhere((element) => element.topic == data.topicId).label}',
              style: TextStyle(color: Colors.black),
              maxLines: 1,
              minFontSize: 8,
              maxFontSize: 14,
            );
          }
        });
  }
}
