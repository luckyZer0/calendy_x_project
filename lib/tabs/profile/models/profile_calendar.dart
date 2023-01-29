import 'package:flutter/foundation.dart' show immutable;

@immutable
class ProfileCalendar {
  final String pcId;
  final String title;
  final String description;
  final String date;
  final String time;

  ProfileCalendar(
    Map<String, dynamic> json, {
    required this.pcId,
  })  : title = json['title'],
        description = json['description'],
        date = json['date'],
        time = json['time'];
}
