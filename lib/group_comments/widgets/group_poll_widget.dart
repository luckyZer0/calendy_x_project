import 'package:calendy_x_project/common/animations/empty_contents_with_text_animation_view.dart';
import 'package:calendy_x_project/common/animations/error_animation.dart';
import 'package:calendy_x_project/common/animations/loading_animation.dart';
import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:calendy_x_project/login/providers/user_info_provider.dart';
import 'package:calendy_x_project/comments/models/group_comment_request.dart';
import 'package:calendy_x_project/group_comments/widgets/vote_tile.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';
import 'package:calendy_x_project/polls/providers/group_poll_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GroupPollView extends HookConsumerWidget {
  final Group group;
  final GroupId groupId;

  const GroupPollView({
    super.key,
    required this.group,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final userInfo = ref.watch(userInfoProvider(group.adminId));
    final request = useState(GroupCommentRequest(groupId: groupId));
    final polls = ref.watch(groupPollsProvider(request.value));

    return Material(
      child: SafeArea(
        child: polls.when(
          data: (polls) {
            if (polls.isEmpty) {
              return const SingleChildScrollView(
                child:
                    EmptyContentWithTextAnimationView(text: Strings.noPollsYet),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () {
                  ref.invalidate(groupPollsProvider(request.value));
                  return Future.delayed(const Duration(seconds: 1));
                },
                child: ListView.builder(
                  // controller: scrollController,
                  // reverse: true,
                  itemCount: polls.length,
                  itemBuilder: (context, index) {
                    final poll = polls.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          VoteTile(
                            userInfo: userInfo,
                            pollComment: poll,
                            group: group,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          },
          error: (error, stackTrace) => const ErrorAnimation(),
          loading: () => LoadingAnimation(isDarkMode: isDarkMode),
        ),
      ),
    );
  }
}
