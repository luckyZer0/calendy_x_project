import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/animations/error_animation.dart';
import 'package:calendy_x_project/common/animations/loading_animation.dart';
import 'package:calendy_x_project/common/auth/providers/user_id_provider.dart';
import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/polls/models/meeting_poll_comment.dart';
import 'package:calendy_x_project/polls/models/voter_poll_request.dart';
import 'package:calendy_x_project/polls/providers/has_vote_poll_provider.dart';
import 'package:calendy_x_project/polls/providers/vote_poll_provider.dart';

class VoteButton extends ConsumerWidget {
  final MeetingPollComment poll;
  const VoteButton({
    super.key,
    required this.poll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final hasVoted = ref.watch(hasVotePollProvider(poll.pollId));
    return hasVoted.when(
      data: (data) {
        return TextButton(
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
          onPressed: () {
            final userId = ref.read(userIdProvider);

            if (userId == null) {
              return;
            }

            final voteRequest = VoterPollRequest(
              pollId: poll.pollId,
              voteBy: userId,
            );
            ref.read(votePollProvider(voteRequest));
          },
        );
      },
      error: (error, stackTrace) => const ErrorAnimation(),
      loading: () => LoadingAnimation(isDarkMode: isDarkMode),
    );
  }
}
