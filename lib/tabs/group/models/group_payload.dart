import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/tabs/group/models/group_key.dart';
import 'package:calendy_x_project/tabs/group/models/group_settings.dart';

@immutable
class GroupPayload extends MapView<String, dynamic> {
  GroupPayload({
    required UserId adminId,
    required String title,
    required String fileUrl,
    required String fileName,
    required double aspectRatio,
    required String thumbnailUrl,
    required String thumbnailStorageId,
    required String originalFileStorageId,
    required Map<GroupSettings, bool> groupSettings,
  }) : super({
          GroupKey.userId: adminId,
          GroupKey.title: title,
          GroupKey.createdAt: FieldValue.serverTimestamp(),
          GroupKey.fileUrl: fileUrl,
          GroupKey.fileName: fileName,
          GroupKey.aspectRatio: aspectRatio,
          GroupKey.thumbnailUrl: thumbnailUrl,
          GroupKey.thumbnailStorageId: thumbnailStorageId,
          GroupKey.originalFileStorageId: originalFileStorageId,
          GroupKey.groupSettings: {
            for (final groupSetting in groupSettings.entries)
              groupSetting.key.storageKey: groupSetting.value,
          },
        });
}
