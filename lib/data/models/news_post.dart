// To parse this JSON data, do
//
//     final newsPost = newsPostFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

NewsPost newsPostFromJson(String str) => NewsPost.fromJson(json.decode(str));

String newsPostToJson(NewsPost data) => json.encode(data.toJson());

class NewsPost {
  NewsPost({
    @required this.mosqueId,
    @required this.body,
    @required this.title,
    @required this.sendNotification,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.topicId,
    @required this.url,
    @required this.draft,
  });

  final String mosqueId;
  final String body;
  final String title;
  final bool sendNotification;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String topicId;
  final String url;
  final bool draft;

  NewsPost copyWith({
    String mosqueId,
    String body,
    String title,
    bool sendNotification,
    DateTime createdAt,
    DateTime updatedAt,
    String topicId,
    String url,
    bool draft,
  }) =>
      NewsPost(
        mosqueId: mosqueId ?? this.mosqueId,
        body: body ?? this.body,
        title: title ?? this.title,
        sendNotification: sendNotification ?? this.sendNotification,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        topicId: topicId ?? this.topicId,
        url: url ?? this.url,
        draft: draft ?? this.draft,
      );

  factory NewsPost.fromJson(Map<String, dynamic> json) => NewsPost(
        mosqueId: json["mosqueId"],
        body: json["body"],
        title: json["title"],
        sendNotification: json["sendNotification"],
        createdAt: json["createdAt"].toDate(),
        updatedAt: json["updatedAt"].toDate(),
        topicId: json["topicId"],
        url: json["url"],
        draft: json["draft"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "mosqueId": mosqueId,
        "body": body,
        "title": title,
        "sendNotification": sendNotification,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "topicId": topicId,
        "url": url,
        "draft": draft,
      };
}
