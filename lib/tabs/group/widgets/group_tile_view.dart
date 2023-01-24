import 'package:calendy_x_project/common/auth/providers/user_id_provider.dart';
import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/dialogs/delete_dialog.dart';
import 'package:calendy_x_project/common/dialogs/extensions/alert_dialog_extension.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/tabs/group/providers/delete_group_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/comments/models/group_comment_request.dart';
import 'package:calendy_x_project/comments/providers/group_with_mini_comment_provider.dart';
import 'package:calendy_x_project/comments/widgets/single_comment.dart';
import 'package:calendy_x_project/common/animations/error_animation.dart';
import 'package:calendy_x_project/common/animations/loading_animation.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/group_comments_polls/views/group_comment_and_poll.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';

class GroupCardView extends ConsumerWidget {
  final Iterable<Group> groups;

  const GroupCardView({
    Key? key,
    required this.groups,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final currentUserId = ref.read(userIdProvider);

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 8.0),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups.elementAt(index);
        final isGroupAdmin = currentUserId == group.adminId;
        final request = GroupCommentRequest(
          groupId: group.groupId,
          limit: 1,
          sortByCreatedAt: true,
        );
        final postWIthComments =
            ref.watch(groupWithMiniCommentProvider(request));
        return Container(
          margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.blackPanther : AppColors.perano,
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onLongPress: isGroupAdmin
                ? () async {
                    final title = group.title;
                    final shouldDeleteGroup = await DeleteDialog(
                            titleOfObjectToDelete: '${Strings.group}: $title')
                        .present(context)
                        .then((shouldDelete) => shouldDelete ?? false);
                    if (shouldDeleteGroup) {
                      await ref
                          .read(deleteGroupProvider.notifier)
                          .deleteGroup(group: group);
                    }
                  }
                : null,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GroupCommentAndPoll(
                  groupId: group.groupId,
                  group: group,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        group.thumbnailUrl,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        postWIthComments.when(
                          data: (comment) {
                            return SingleComment(comments: comment.comments);
                          },
                          error: (error, stackTrace) => const ErrorAnimation(),
                          loading: () =>
                              LoadingAnimation(isDarkMode: isDarkMode),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
