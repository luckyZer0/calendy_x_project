import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/polls/models/meeting_poll.dart';

@immutable
class MeetingPollPayload extends MapView<String, dynamic> {
  MeetingPollPayload({
    required String title,
    required String description,
    required UserId userId,
    required GroupId groupId,
    required Iterable<MeetingPoll> meetingPolls,
    required bool buttonPressed,
  }) : super({
          FirebaseFieldName.title: title,
          FirebaseFieldName.description: description,
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.groupId: groupId,
          FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
          FirebaseFieldName.meetingPolls:
              meetingPolls.map((m) => m.toJson()).toList(),
          FirebaseFieldName.buttonPressed: buttonPressed,
        });
}
