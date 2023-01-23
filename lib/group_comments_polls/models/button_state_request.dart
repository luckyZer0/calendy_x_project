import 'dart:collection';

import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/polls/typedefs/poll_id.dart';

@immutable
class ButtonStateRequest extends MapView<String, dynamic> {
  final PollId pollId;
  final UserId userId;
  final GroupId groupId;
  final bool buttonPressed;

  ButtonStateRequest({
    required this.pollId,
    required this.userId,
    required this.groupId,
    required this.buttonPressed,
  }) : super({
          FirebaseFieldName.pollId: pollId,
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.groupId: groupId,
          FirebaseFieldName.buttonPressed: buttonPressed,
        });
}
