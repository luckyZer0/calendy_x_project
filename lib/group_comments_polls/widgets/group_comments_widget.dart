import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/comments/models/group_comment_request.dart';
import 'package:calendy_x_project/comments/providers/group_comment_provider.dart';
import 'package:calendy_x_project/comments/providers/send_comment_provider.dart';
import 'package:calendy_x_project/comments/view/comment_tile.dart';
import 'package:calendy_x_project/common/animations/empty_contents_with_text_animation_view.dart';
import 'package:calendy_x_project/common/animations/error_animation.dart';
import 'package:calendy_x_project/common/animations/loading_animation.dart';
import 'package:calendy_x_project/common/auth/providers/user_id_provider.dart';
import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/dismiss_keyboard/dismiss_keyboard.dart';
import 'package:calendy_x_project/common/extensions/dismiss_keyboard.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';

class GroupCommentsView extends HookConsumerWidget {
  final Group group;
  final GroupId groupId;

  const GroupCommentsView({
    super.key,
    required this.group,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final textController = useTextEditingController();
    final hasText = useState(false);

    final request = useState(GroupCommentRequest(groupId: groupId));
    final comments = ref.watch(groupCommentsProvider(request.value));

    useEffect(() {
      textController
          .addListener(() => hasText.value = textController.text.isNotEmpty);
      return () {};
    }, [textController]);
    return DismissKeyboardWidget(
      child: Material(
        child: SafeArea(
          child: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                flex: 4,
                child: comments.when(
                  data: (comments) {
                    if (comments.isEmpty) {
                      return const SingleChildScrollView(
                        child: EmptyContentWithTextAnimationView(
                            text: Strings.noCommentsYet),
                      );
                    } else {
                      return RefreshIndicator(
                        onRefresh: () {
                          ref.invalidate(groupCommentsProvider(request.value));
                          return Future.delayed(const Duration(seconds: 1));
                        },
                        child: ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments.elementAt(index);
                            return CommentTile(
                              comment: comment,
                              group: group,
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextField(
                          textInputAction: TextInputAction.send,
                          controller: textController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: Strings.writeYourCommentHere,
                            suffixIcon: IconButton(
                              onPressed: hasText.value
                                  ? () => _submitCommentController(
                                        textController,
                                        ref,
                                      )
                                  : null,
                              icon: const Icon(Icons.send_rounded),
                            ),
                          ),
                          onSubmitted: (comment) {
                            if (comment.isNotEmpty) {
                              _submitCommentController(
                                textController,
                                ref,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitCommentController(
    TextEditingController controller,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);

    if (userId == null) {
      return;
    }

    final isSent = await ref.read(sendCommentProvider.notifier).sendComment(
          userId: userId,
          groupId: groupId,
          comment: controller.text,
        );
    if (isSent) {
      controller.clear();
      dismissKeyboard();
    }
  }
}
