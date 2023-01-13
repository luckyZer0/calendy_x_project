import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/typedef/is_loading.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/image_upload/constants/constants.dart';
import 'package:calendy_x_project/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:calendy_x_project/image_upload/extensions/get_image_data_aspect_ratio.dart';
import 'package:calendy_x_project/tabs/group/models/group_payload.dart';
import 'package:calendy_x_project/tabs/group/models/group_settings.dart';

class ImageUploadNotifier extends StateNotifier<IsLoading> {
  ImageUploadNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> upload({
    required File file,
    required String title,
    required Map<GroupSettings, bool> groupSettings,
    required UserId userId,
  }) async {
    isLoading = true;

    late Uint8List thumbnailUint8List;

    final imageFile = img.decodeImage(file.readAsBytesSync());

    // check image state
    if (imageFile == null) {
      isLoading = false;
      throw const CouldNotBuildThumbnailException();
    }

    // create thumbnail
    final thumbnail = img.copyResize(
      imageFile,
      width: Constants.imageThumbnailWidth,
    );

    final thumbnailData = img.encodeJpg(thumbnail);
    thumbnailUint8List = Uint8List.fromList(thumbnailData);

    // calculate the aspect ratio
    final thumbnailAspectRatio =
        await thumbnailUint8List.getImageDataAspectRatio();

    // calculate references for the file name
    final fileName = const Uuid().v4();

    // create references to the thumbnail and the image itself
    final thumbnailRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(FirebaseCollectionName.thumbnails)
        .child(fileName);

    final originalFileRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(FirebaseCollectionName.images)
        .child(fileName);

    try {
      // upload the thumbnail
      final thumbnailUploadTask =
          await thumbnailRef.putData(thumbnailUint8List);
      final thumbnailStorageId = thumbnailUploadTask.ref.name;

      // upload the original file
      final originalFileUploadTask = await originalFileRef.putFile(file);
      final originalFileStorageId = originalFileUploadTask.ref.name;

      //upload the group itself
      final groupPayload = GroupPayload(
        adminId: userId,
        title: title,
        fileUrl: await originalFileRef.getDownloadURL(),
        fileName: fileName,
        aspectRatio: thumbnailAspectRatio,
        thumbnailUrl: await thumbnailRef.getDownloadURL(),
        thumbnailStorageId: thumbnailStorageId,
        originalFileStorageId: originalFileStorageId,
        groupSettings: groupSettings,
        memberId: [userId],
      );
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.groups)
          .add(groupPayload);
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
