import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/comments/providers/delete_comment_provider.dart';
import 'package:calendy_x_project/common/auth/providers/auth_state_provider.dart';
import 'package:calendy_x_project/group_comments_polls/providers/button_pressed_notifier_provider.dart';
import 'package:calendy_x_project/image_upload/providers/image_uploader_provider.dart';
import 'package:calendy_x_project/polls/providers/send_meeting_poll_provider.dart';
import 'package:calendy_x_project/tabs/group/providers/delete_group_provider.dart';

// managing loading state
final isLoadingProvider = Provider<bool>(
  (ref) {
    final authState = ref.watch(authStateProvider);
    final isUploadingImage = ref.watch(imageUploaderProvider);
    final isDeletingComment = ref.watch(deleteCommentProvider);
    final isDeletingGroup = ref.watch(deleteGroupProvider);
    final isSendingPoll = ref.watch(sendMeetingPollProvider);
    final isPressed = ref.watch(buttonPressedNotifierProvider);

    return authState.isLoading ||
        isUploadingImage ||
        isDeletingGroup ||
        isDeletingComment ||
        isSendingPoll ||
        isPressed;
  },
);
