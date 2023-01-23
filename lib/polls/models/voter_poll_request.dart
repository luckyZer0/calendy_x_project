import 'package:flutter/foundation.dart' show immutable;

import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/polls/typedefs/poll_id.dart';

@immutable
class VoterPollRequest {
  final PollId pollId;
  final GroupId groupId;
  final UserId voteBy;

  const VoterPollRequest({
    required this.pollId,
    required this.groupId,
    required this.voteBy,
  });
}
