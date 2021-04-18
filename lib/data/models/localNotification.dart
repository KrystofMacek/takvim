import 'package:flutter/cupertino.dart';

class LocalNotification {
  const LocalNotification(
      DateTime dateTime, int minutes, int timeName, String timeDisplayed)
      : dateOfNotification = dateTime,
        minutesBefore = minutes,
        nameOfTime = timeName,
        timeDisplayed = timeDisplayed;

  final DateTime dateOfNotification;
  final int minutesBefore;
  final int nameOfTime;
  final String timeDisplayed;
}
