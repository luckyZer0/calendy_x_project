import 'package:calendy_x_project/comments/models/comment.dart';
import 'package:calendy_x_project/comments/widgets/two_part_text.dart';
import 'package:calendy_x_project/common/animations/small_error_animation.dart';
import 'package:calendy_x_project/login/providers/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MiniCommentTile extends ConsumerWidget {
  final Comment comment;

  const MiniCommentTile({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider(comment.userId));
    return userInfo.when(
      data: (userInfo) {
        return TwoPartsText(
          leftPart: userInfo.displayName,
          rightPart: comment.comment,
        );
      },
      error: (error, stackTrace) => const SmallErrorAnimation(),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
