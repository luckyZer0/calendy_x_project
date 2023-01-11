import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/animations/error_animation.dart';
import 'package:calendy_x_project/common/animations/loading_animation.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/image_upload/models/thumbnail_request.dart';
import 'package:calendy_x_project/image_upload/providers/thumbnail_provider.dart';

class ImageThumbnailView extends ConsumerWidget {
  final ThumbnailRequest thumbnailRequest;

  const ImageThumbnailView({
    super.key,
    required this.thumbnailRequest,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final thumbnail = ref.watch(thumbnailProvider(thumbnailRequest));
    return thumbnail.when(
      data: (imageWithAspectRatio) => CircleAvatar(
        radius: 100.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: AspectRatio(
            aspectRatio: imageWithAspectRatio.aspectRatio,
            child: imageWithAspectRatio.image,
          ),
        ),
      ),
      error: (error, stackTrace) => const ErrorAnimation(),
      loading: () => LoadingAnimation(
        isDarkMode: isDarkMode,
        loadingWidth: 350.0,
      ),
    );
  }
}
