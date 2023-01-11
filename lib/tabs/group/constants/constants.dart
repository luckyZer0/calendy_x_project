import 'package:flutter/foundation.dart' show immutable;

@immutable
class Constants {
  static const allowCommentsTitle = 'Allow comments';
  static const allowCommentsDescription =
      'By allowing comments, users will be able to comment in your group chat.';
  static const allowCommentsStorageKey = 'allow_comments';
  const Constants._();
}
