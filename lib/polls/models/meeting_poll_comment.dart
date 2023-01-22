import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/common/enums/date_sorting.dart';
import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/polls/models/meeting_poll.dart';
import 'package:calendy_x_project/polls/typedefs/poll_id.dart';

@immutable
class MeetingPollComment extends Equatable {
  final PollId pollId;
  final String title;
  final String description;
  final UserId userId;
  final GroupId groupId;
  final List<MeetingPoll> meetingPolls;
  final bool sortByCreatedAt;
  final DateSorting dateSorting;
  final DateTime createdAt;

  const MeetingPollComment({
    required this.pollId,
    required this.title,
    required this.description,
    required this.userId,
    required this.groupId,
    required this.meetingPolls,
    required this.sortByCreatedAt,
    required this.dateSorting,
    required this.createdAt,
  });

  factory MeetingPollComment.fromJson(Map<String, dynamic> json,
      {required String pollId}) {
    final meetingPolls = (json[FirebaseFieldName.meetingPolls] as List)
        .map((poll) => MeetingPoll.fromJson(poll))
        .toList();

    return MeetingPollComment(
      pollId: pollId,
      title: json[FirebaseFieldName.title],
      description: json[FirebaseFieldName.description],
      userId: json[FirebaseFieldName.userId],
      groupId: json[FirebaseFieldName.groupId],
      meetingPolls: meetingPolls,
      createdAt: (json[FirebaseFieldName.createdAt] as Timestamp).toDate(),
      dateSorting: DateSorting.newestOnTop,
      sortByCreatedAt: true,
    );
  }

  @override
  List<Object?> get props => [
        pollId,
        userId,
        groupId,
        title,
        description,
        meetingPolls,
        dateSorting,
        sortByCreatedAt,
        createdAt,
      ];
}
