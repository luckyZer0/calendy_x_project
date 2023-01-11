import 'package:flutter/foundation.dart' show immutable;

// TODO: need to add group url?

@immutable
class GroupKey {
  static const userId = 'uid';
  static const title = 'title';
  static const createdAt = 'created_at';
  static const fileUrl = 'file_url';
  static const fileName = 'file_name';
  static const aspectRatio = 'aspect_ratio';
  static const thumbnailUrl = 'thumbnail_url';
  static const thumbnailStorageId = 'thumbnail_storage_id';
  static const originalFileStorageId = 'original_file_storage_id';
  static const groupSettings = 'group_settings';

  const GroupKey._();
}
