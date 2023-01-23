import 'dart:collection';

import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/polls/typedefs/poll_id.dart';

@immutable
class VoterPoll extends MapView<String, String> {
  VoterPoll({
    required PollId pollId,
    required GroupId groupId,
    required UserId voteBy,
    required DateTime date,
  }) : super({
          FirebaseFieldName.pollId: pollId,
          FirebaseFieldName.groupId: groupId,
          FirebaseFieldName.userId: voteBy,
          FirebaseFieldName.date: date.toIso8601String(),
        });
}

