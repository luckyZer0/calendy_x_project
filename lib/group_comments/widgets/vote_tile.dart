import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

import 'package:calendy_x_project/common/auth/providers/user_id_provider.dart';
import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/login/models/user_info_model.dart';
import 'package:calendy_x_project/group_comments/widgets/vote_list_card.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';
import 'package:calendy_x_project/polls/models/meeting_poll_comment.dart';

class VoteTile extends HookConsumerWidget {
  final Group group;
  final AsyncValue<UserInfoModel> userInfo;
  // final MeetingPoll poll;
  final MeetingPollComment pollComment;

  const VoteTile({
    Key? key,
    required this.group,
    required this.userInfo,
    // required this.poll,
    required this.pollComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isDarkMode = ref.watch(themeModeProvider);
    final currentUserId = ref.read(userIdProvider);
    final isGroupAdmin = currentUserId == group.adminId;

    return Material(
      color: isDarkMode ? AppColors.blackPanther : AppColors.perano,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(userInfo.value!.photoURL!),
        ),
        title: Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
            top: 6.0,
          ),
          child: Text(
            ReCase(userInfo.value!.displayName).titleCase,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                4.0,
                6.0,
                0,
                8.0,
              ),
              child: Text(pollComment.title),
            ),
            VoteListCard(
              pollComment: pollComment,
              isDarkMode: isDarkMode,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isGroupAdmin
                    ? Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: TextButton(
                          style: isDarkMode
                              ? TextButton.styleFrom(
                                  backgroundColor: AppColors.perano,
                                  foregroundColor: AppColors.blackPanther,
                                )
                              : TextButton.styleFrom(
                                  backgroundColor: AppColors.ebonyClay,
                                  foregroundColor: AppColors.perano,
                                ),
                          child: const Text(Strings.confirmMeeting),
                          onPressed: () {},
                        ),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Text(
                    DateFormat.MMMMd().add_jm().format(pollComment.createdAt),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
