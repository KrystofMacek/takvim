// To parse this JSON data, do
//
//     final subsTopic = subsTopicFromJson(jsonString);

import 'package:meta/meta.dart';
import './mosque_data.dart';
import 'dart:convert';

SubsTopic subsTopicFromJson(String str) => SubsTopic.fromJson(json.decode(str));

String subsTopicToJson(SubsTopic data) => json.encode(data.toJson());

class SubsTopic {
  SubsTopic(
      {@required this.label,
      @required this.mosqueId,
      @required this.topic,
      @required this.mosqueName,
      this.refMosque});

  final String label;
  final String mosqueId;
  final String topic;
  final String mosqueName;
  MosqueData refMosque;

  SubsTopic copyWith({
    String label,
    String mosqueId,
    String topic,
    String mosqueName,
    MosqueData refMosque,
  }) =>
      SubsTopic(
        label: label ?? this.label,
        mosqueId: mosqueId ?? this.mosqueId,
        topic: topic ?? this.topic,
        mosqueName: mosqueName ?? this.mosqueName,
        refMosque: refMosque ?? this.refMosque,
      );

  factory SubsTopic.fromJson(Map<String, dynamic> json) => SubsTopic(
        label: json["label"],
        mosqueId: json["mosqueID"],
        topic: json["topic"],
        mosqueName: json["mosqueName"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "mosqueID": mosqueId,
        "topic": topic,
        "mosqueName": mosqueName,
      };
}
