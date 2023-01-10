import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseCollectionName {
  static const users = 'users';
  static const groups = 'groups';
  static const comments = 'comments';
  static const thumbnails = 'thumbnails';
  static const votes = 'votes';
  static const images = 'images';
  static const meetingPoll = 'meetings';

  const FirebaseCollectionName._();
}