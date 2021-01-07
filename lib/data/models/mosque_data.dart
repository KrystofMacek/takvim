// To parse this JSON data, do
//
//     final mosqueData = mosqueDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MosqueData mosqueDataFromJson(String str) =>
    MosqueData.fromJson(json.decode(str));

String mosqueDataToJson(MosqueData data) => json.encode(data.toJson());

class MosqueData {
  MosqueData({
    @required this.mosqueId,
    @required this.kanton,
    @required this.name,
    @required this.ort,
  });

  final String mosqueId;
  final String kanton;
  final String name;
  final String ort;

  MosqueData copyWith({
    String mosqueId,
    String kanton,
    String name,
    String ort,
  }) =>
      MosqueData(
        mosqueId: mosqueId ?? this.mosqueId,
        kanton: kanton ?? this.kanton,
        name: name ?? this.name,
        ort: ort ?? this.ort,
      );

  factory MosqueData.fromJson(Map<String, dynamic> json) => MosqueData(
        mosqueId: json["MosqueID"],
        kanton: json["Kanton"],
        name: json["Name"],
        ort: json["Ort"],
      );

  factory MosqueData.fromFirebase(Map<dynamic, dynamic> json) => MosqueData(
        mosqueId: json["MosqueID"],
        kanton: json["Kanton"],
        name: json["Name"],
        ort: json["Ort"],
      );

  Map<String, dynamic> toJson() => {
        "MosqueID": mosqueId,
        "Kanton": kanton,
        "Name": name,
        "Ort": ort,
      };
}
