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
    @required this.email,
    @required this.kanton,
    @required this.mosqueId,
    @required this.name,
    @required this.offiziellerName,
    @required this.ort,
    @required this.plz,
    @required this.strasse,
    @required this.telefon,
    @required this.website,
    @required this.distance,
    @required this.coords,
  });

  final String email;
  final String kanton;
  final String mosqueId;
  final String name;
  final String offiziellerName;
  final String ort;
  final String plz;
  final String strasse;
  final String telefon;
  final String website;
  final Map<String, dynamic> coords;
  final double distance;

  MosqueData copyWith({
    String email,
    String kanton,
    String mosqueId,
    String name,
    String offiziellerName,
    String ort,
    String plz,
    String strasse,
    String telefon,
    String website,
    Map<String, dynamic> coords,
    double distance,
  }) =>
      MosqueData(
        email: email ?? this.email,
        kanton: kanton ?? this.kanton,
        mosqueId: mosqueId ?? this.mosqueId,
        name: name ?? this.name,
        offiziellerName: offiziellerName ?? this.offiziellerName,
        ort: ort ?? this.ort,
        plz: plz ?? this.plz,
        strasse: strasse ?? this.strasse,
        telefon: telefon ?? this.telefon,
        website: website ?? this.website,
        distance: distance ?? this.distance,
        coords: coords ?? this.coords,
      );

  factory MosqueData.fromJson(Map<String, dynamic> json) => MosqueData(
        email: json["Email"],
        kanton: json["Kanton"],
        mosqueId: json["MosqueID"],
        name: json["Name"],
        offiziellerName: json["OffiziellerName"],
        ort: json["Ort"],
        plz: json["Plz"],
        strasse: json["Strasse"],
        telefon: json["Telefon"],
        website: json["Website"],
        coords: json["coords"],
        distance: 0.0,
      );

  factory MosqueData.fromFirebase(Map<dynamic, dynamic> json) => MosqueData(
        email: json["Email"],
        kanton: json["Kanton"],
        mosqueId: json["MosqueID"],
        name: json["Name"],
        offiziellerName: json["OffiziellerName"],
        ort: json["Ort"],
        plz: json["Plz"],
        strasse: json["Strasse"],
        telefon: json["Telefon"],
        website: json["Website"],
        coords: json["coords"],
        distance: 0.0,
      );

  Map<String, dynamic> toJson() => {
        "Email": email,
        "Kanton": kanton,
        "MosqueID": mosqueId,
        "Name": name,
        "OffiziellerName": offiziellerName,
        "Ort": ort,
        "Plz": plz,
        "Strasse": strasse,
        "Telefon": telefon,
        "Website": website,
        "coords": coords,
      };
}
