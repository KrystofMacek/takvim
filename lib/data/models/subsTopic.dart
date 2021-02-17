// To parse this JSON data, do
//
//     final subsTopic = subsTopicFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'subsTopic.g.dart';

@HiveType(typeId: 0, adapterName: 'SubsTopicAdapter')
class SubsTopic extends Equatable {
  SubsTopic({
    @required this.topic,
    @required this.label,
    @required this.mosqueId,
  });
  @HiveField(0)
  final String topic;
  @HiveField(1)
  final String label;
  @HiveField(2)
  final String mosqueId;

  SubsTopic copyWith({
    String topic,
    String label,
    String mosqueId,
  }) =>
      SubsTopic(
        topic: topic ?? this.topic,
        label: label ?? this.label,
        mosqueId: mosqueId ?? this.mosqueId,
      );

  factory SubsTopic.fromJson(String topicId, Map<String, dynamic> json) =>
      SubsTopic(
        topic: topicId,
        label: json["name"],
        mosqueId: json["mosqueId"],
      );

  Map<String, dynamic> toJson() => {
        "name": label,
        "mosqueId": mosqueId,
      };

  @override
  List<Object> get props => [topic];
}
