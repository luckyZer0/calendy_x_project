import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseCollectionName {
  static const users = 'users';
  static const members = 'members';
  static const groups = 'groups';
  static const groupMember = 'group_member';
  static const comments = 'comments';
  static const thumbnails = 'thumbnails';
  static const votes = 'votes';
  static const images = 'images';
  static const meetingPoll = 'meetings';
  static const buttonState = 'button_states';

  const FirebaseCollectionName._();
}