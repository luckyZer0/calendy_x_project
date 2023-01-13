import 'dart:collection';


import 'package:flutter/foundation.dart';

import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';

@immutable
class JoinGroupPayload extends MapView<String, dynamic> {
  JoinGroupPayload({
    // required GroupId groupId,
    required List<UserId> members,
  }) : super({
    // FirebaseFieldName.groupId: groupId,
    FirebaseFieldName.memberId: members,
  });
}

// class JoinGroup extends Equatable {
//   final GroupId groupId;
//   final Iterable<UserId> userId;

//   const JoinGroup({
//     required this.groupId,
//     required this.userId,
//   });

//   factory JoinGroup.fromJson(Map<String, dynamic> json) {
//   return JoinGroup(
//     groupId: json[FirebaseFieldName.groupId] as String,
//     userId: json['user_id'],
//   );
// }

// Map<String, dynamic> toJson() {
//   return {
//     'group_id': groupId,
//     'user_id': userId,
//   };
// }

//   @override
//   List<Object?> get props => [
//         groupId,
//         userId,
//       ];
// }
