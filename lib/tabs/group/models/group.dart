import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/tabs/group/models/group_key.dart';
import 'package:calendy_x_project/tabs/group/models/group_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class Group {
  final String groupId;
  final UserId adminId;
  final String title;
  late final DateTime createdAt;
  final String fileUrl;
  final String fileName;
  final double aspectRatio;
  final String thumbnailUrl;
  final String thumbnailStorageId;
  final String originalFileStorageId;
  final Map<GroupSettings, bool> groupSettings;

  Group({
    required this.groupId,
    required Map<String, dynamic> json,
  })  : adminId = json[GroupKey.userId],
        title = json[GroupKey.title],
        createdAt = json[GroupKey.createdAt] != null
            ? (json[GroupKey.createdAt] as Timestamp).toDate()
            : DateTime.now(),
        fileUrl = json[GroupKey.fileUrl],
        fileName = json[GroupKey.fileName],
        aspectRatio = json[GroupKey.aspectRatio],
        thumbnailUrl = json[GroupKey.thumbnailUrl],
        thumbnailStorageId = json[GroupKey.thumbnailStorageId],
        originalFileStorageId = json[GroupKey.originalFileStorageId],
        groupSettings = {
          for (final entry in json[GroupKey.groupSettings].entries)
            GroupSettings.values.firstWhere(
              (element) => element.storageKey == entry.key,
            ): entry.value,
        };

  bool get allowsComments =>
      groupSettings[GroupSettings.allowComments] ?? false;
}
