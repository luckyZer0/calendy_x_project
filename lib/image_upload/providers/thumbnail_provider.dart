

import 'package:calendy_x_project/image_upload/extensions/get_image_aspect_ratio.dart';
import 'package:calendy_x_project/image_upload/models/image_with_aspect_ratio.dart';
import 'package:calendy_x_project/image_upload/models/thumbnail_request.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final thumbnailProvider =
    FutureProvider.family.autoDispose<ImageWithAspectRatio, ThumbnailRequest>(
  (ref, thumbnailRequest) async {
    final Image image;
    image = Image.file(
      thumbnailRequest.file,
      fit: BoxFit.cover,
    );

    final aspectRatio = await image.getImageAspectRatio();
    return ImageWithAspectRatio(
      image: image,
      aspectRatio: aspectRatio,
    );
  },
);
