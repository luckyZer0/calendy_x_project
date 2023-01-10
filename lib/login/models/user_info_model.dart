import 'dart:collection' show MapView;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';

@immutable
class UserInfoModel extends MapView<String, dynamic> with EquatableMixin {
  final UserId userId;
  final String displayName;
  final String? email;
  final String? photoURL;

  UserInfoModel({
    required this.userId,
    required this.displayName,
    required this.email,
    required this.photoURL,
  }) : super({
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email,
          FirebaseFieldName.photoURL: photoURL,
        });

  UserInfoModel.fromJson(
    Map<String, dynamic> json, {
    required UserId userId,
  }) : this(
          userId: userId,
          displayName: json[FirebaseFieldName.displayName] ?? '',
          email: json[FirebaseFieldName.email],
          photoURL: json[FirebaseFieldName.photoURL],
        );

  @override
  List<Object?> get props => [
        userId,
        displayName,
        email,
        photoURL,
      ];
}
