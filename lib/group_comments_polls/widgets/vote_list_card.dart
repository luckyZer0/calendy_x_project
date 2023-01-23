import 'package:calendy_x_project/group_comments_polls/providers/button_pressed_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/animations/error_animation.dart';
import 'package:calendy_x_project/common/animations/loading_animation.dart';
import 'package:calendy_x_project/common/auth/providers/user_id_provider.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/polls/models/meeting_poll_comment.dart';
import 'package:calendy_x_project/polls/models/voter_poll_request.dart';
import 'package:calendy_x_project/polls/providers/vote_count_provider.dart';
import 'package:calendy_x_project/polls/providers/vote_poll_provider.dart';

class VoteListCard extends ConsumerWidget {
  const VoteListCard({
    Key? key,
    required this.pollComment,
    required this.isDarkMode,
  }) : super(key: key);

  final MeetingPollComment pollComment;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStateCounter =
        ref.watch(buttonStatePressedProvider(pollComment.pollId)).value;
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: pollComment.meetingPolls.length,
      itemBuilder: (context, index) {
        final meetingPoll = pollComment.meetingPolls[index];
        final voteCount = ref.watch(voteCountProvider(meetingPoll.pollId));
        return Card(
          color: isDarkMode ? AppColors.jumbo : AppColors.white,
          child: InkWell(
            onTap: buttonStateCounter == 0
                ? () {
                    final id = meetingPoll.pollId;
                    final userId = ref.read(userIdProvider);

                    if (userId == null) {
                      return;
                    }

                    final voteRequest = VoterPollRequest(
                      pollId: id,
                      voteBy: userId,
                      groupId: pollComment.groupId,
                    );

                    ref.read(votePollProvider(voteRequest));
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 5,
                    child: Text(meetingPoll.date),
                  ),
                  const Spacer(flex: 2),
                  Flexible(
                    flex: 3,
                    child: Text(meetingPoll.time),
                  ),
                  const Spacer(flex: 3),
                  Flexible(
                    child: voteCount.when(
                      data: (count) {
                        return Text(count.toString());
                      },
                      error: (error, stackTrace) => const ErrorAnimation(),
                      loading: () => LoadingAnimation(isDarkMode: isDarkMode),
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
