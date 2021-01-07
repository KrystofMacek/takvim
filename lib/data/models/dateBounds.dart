// To parse this JSON data, do
//
//     final dateBounds = dateBoundsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class DateBounds {
  DateBounds({
    @required this.firstDate,
    @required this.lastDate,
  });

  final DateTime firstDate;
  final DateTime lastDate;

  DateBounds copyWith({
    String firstDate,
    String lastDate,
  }) =>
      DateBounds(
        firstDate: firstDate ?? this.firstDate,
        lastDate: lastDate ?? this.lastDate,
      );

  factory DateBounds.fromFirebase(Map<dynamic, dynamic> json) => DateBounds(
        firstDate: DateTime.parse(json["firstDate"]),
        lastDate: DateTime.parse(json["lastDate"]),
      );
}
