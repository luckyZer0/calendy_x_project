import 'dart:collection' show MapView;

import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/polls/typedefs/poll_id.dart';

@immutable
class ButtonState extends MapView<String, dynamic> {
  ButtonState({
    required PollId pollId,
    required UserId userId,
    required bool buttonPressed,
  }) : super({
    FirebaseFieldName.pollId: pollId,
    FirebaseFieldName.userId: userId,
    FirebaseFieldName.buttonPressed: buttonPressed,
  });

}
