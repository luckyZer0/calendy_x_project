import 'package:calendy_x_project/group_comments_polls/providers/button_pressed_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

import 'package:calendy_x_project/common/auth/providers/user_id_provider.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/group_comments_polls/widgets/vote_button.dart';
import 'package:calendy_x_project/group_comments_polls/widgets/vote_list_card.dart';
import 'package:calendy_x_project/login/models/user_info_model.dart';
import 'package:calendy_x_project/polls/models/meeting_poll.dart';
import 'package:calendy_x_project/polls/models/meeting_poll_comment.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';

class VoteTile extends HookConsumerWidget {
  final Group group;
  final AsyncValue<UserInfoModel> userInfo;
  final MeetingPollComment pollComment;
  final int index;
  final Iterable<MeetingPollComment> polls;
  final MeetingPoll poll;

  const VoteTile({
    Key? key,
    required this.group,
    required this.userInfo,
    required this.pollComment,
    required this.index,
    required this.polls,
    required this.poll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final currentUserId = ref.read(userIdProvider);
    final isGroupAdmin = currentUserId == group.adminId;
    final buttonStateCounter =
        ref.watch(buttonStatePressedProvider(pollComment.pollId)).value;

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
                2.0,
              ),
              child: Text(
                pollComment.title,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                4.0,
                6.0,
                0,
                8.0,
              ),
              child: Text(pollComment.description),
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
                        child: VoteButton(
                          isDarkMode: isDarkMode,
                          pollComment: pollComment,
                          polls: polls,
                          poll: poll,
                        ),
                      )
                    : buttonStateCounter == 0
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Pending...',
                              overflow: TextOverflow.clip,
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Confirmed',
                              overflow: TextOverflow.clip,
                            ),
                          ),
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
