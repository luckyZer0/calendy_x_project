
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

import 'package:calendy_x_project/common/animations/loading_animation.dart';
import 'package:calendy_x_project/common/animations/small_error_animation.dart';
import 'package:calendy_x_project/common/auth/providers/user_id_provider.dart';
import 'package:calendy_x_project/common/dialogs/delete_dialog.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/login/providers/user_info_provider.dart';
import 'package:calendy_x_project/comments/models/comment.dart';
import 'package:calendy_x_project/comments/providers/delete_comment_provider.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';

class CommentTile extends ConsumerWidget {
  final Comment comment;
  final Group group;
  const CommentTile({
    super.key,
    required this.comment,
    required this.group,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final userInfo = ref.watch(userInfoProvider(comment.userId));

    Future<void> deleteComment() async {
      final shouldDeleteComment = await displayDeleteDialog(context);
      if (shouldDeleteComment) {
        await ref
            .read(deleteCommentProvider.notifier)
            .deleteComment(commentId: comment.id);
      }
    }

    return userInfo.when(
      data: (userInfo) {
        final currentUserId = ref.read(userIdProvider);
        final isCurrentUser = currentUserId == comment.userId;
        final isGroupAdmin = currentUserId == group.adminId;

        return isCurrentUser
            ? InkWell(
                onLongPress: isGroupAdmin || isCurrentUser
                    ? () => deleteComment()
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 14,
                        right: 60,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(userInfo.photoURL!),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? AppColors.blackPanther
                                      : AppColors.perano,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ReCase(
                                        userInfo.displayName,
                                      ).titleCase,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Text(
                                        comment.comment,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 60.0),
                      child: Text(
                        DateFormat.jm().format(comment.createdAt),
                      ),
                    ),
                  ],
                ),
              )
            : InkWell(
                onLongPress: isGroupAdmin || isCurrentUser
                    ? () => deleteComment()
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 60,
                        right: 14,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? AppColors.blackPanther
                                      : AppColors.perano,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ReCase(userInfo.displayName).titleCase,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Text(
                                        comment.comment,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          CircleAvatar(
                            backgroundImage: NetworkImage(userInfo.photoURL!),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0),
                      child: Text(
                        DateFormat.jm().format(comment.createdAt),
                      ),
                    ),
                  ],
                ),
              );
      },
      error: (error, stackTrace) => const SmallErrorAnimation(),
      loading: () => LoadingAnimation(isDarkMode: isDarkMode),
    );
  }
}
