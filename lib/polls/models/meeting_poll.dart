import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:calendy_x_project/common/constants/firebase_field_name.dart';

@immutable
class MeetingPoll extends Equatable {
  final String pollId;
  final String date;
  final String time;

  const MeetingPoll({
    required this.pollId,
    required this.date,
    required this.time,
  });

  factory MeetingPoll.fromJson(Map<String, dynamic> json) {
    return MeetingPoll(
      pollId: json[FirebaseFieldName.pollId] as String,
      date: json[FirebaseFieldName.date] as String,
      time: json[FirebaseFieldName.time] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        FirebaseFieldName.pollId: pollId,
        FirebaseFieldName.date: date,
        FirebaseFieldName.time: time,
      };

  @override
  List<Object?> get props => [
        pollId,
        date,
        time,
      ];
}
