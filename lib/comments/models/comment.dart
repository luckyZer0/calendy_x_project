import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/common/typedef/comment_id.dart';
import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';

@immutable
class Comment extends Equatable {
  final CommentId id;
  final String comment;
  final DateTime createdAt;
  final UserId userId;
  final GroupId groupId;

  Comment(Map<String, dynamic> json, {required this.id})
      : comment = json[FirebaseFieldName.comment],
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate(),
        userId = json[FirebaseFieldName.userId],
        groupId = json[FirebaseFieldName.groupId];

  @override
  List<Object?> get props => [
        id,
        comment,
        createdAt,
        userId,
        groupId,
      ];
}
