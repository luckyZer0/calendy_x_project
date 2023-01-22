import 'dart:collection';

import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/polls/typedefs/poll_id.dart';

@immutable
class ButtonStateRequest extends MapView<String, dynamic> {
  final PollId pollId;
  final UserId userId;
  final bool buttonPressed;

  ButtonStateRequest({
    required this.pollId,
    required this.userId,
    required this.buttonPressed,
  }) : super({
          FirebaseFieldName.pollId: pollId,
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.buttonPressed: buttonPressed,
        });
}
