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
    @required this.notificationBody,
    @required this.notificationTitle,
    @required this.sendNotification,
    @required this.timeStamp,
    @required this.topic,
    @required this.url,
  });

  final String mosqueId;
  final String notificationBody;
  final String notificationTitle;
  final bool sendNotification;
  final DateTime timeStamp;
  final String topic;
  final String url;

  NewsPost copyWith({
    String mosqueId,
    String notificationBody,
    String notificationTitle,
    bool sendNotification,
    DateTime timeStamp,
    String topic,
    String url,
  }) =>
      NewsPost(
        mosqueId: mosqueId ?? this.mosqueId,
        notificationBody: notificationBody ?? this.notificationBody,
        notificationTitle: notificationTitle ?? this.notificationTitle,
        sendNotification: sendNotification ?? this.sendNotification,
        timeStamp: timeStamp ?? this.timeStamp,
        topic: topic ?? this.topic,
        url: url ?? this.url,
      );

  factory NewsPost.fromJson(Map<String, dynamic> json) => NewsPost(
        mosqueId: json["mosqueId"],
        notificationBody: json["notificationBody"],
        notificationTitle: json["notificationTitle"],
        sendNotification: json["sendNotification"],
        timeStamp: json["timeStamp"].toDate(),
        topic: json["topic"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "mosqueId": mosqueId,
        "notificationBody": notificationBody,
        "notificationTitle": notificationTitle,
        "sendNotification": sendNotification,
        "timeStamp": timeStamp,
        "topic": topic,
        "url": url,
      };
}
