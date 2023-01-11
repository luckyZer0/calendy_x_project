import 'package:calendy_x_project/comments/providers/delete_comment_provider.dart';
import 'package:calendy_x_project/comments/providers/send_comment_provider.dart';
import 'package:calendy_x_project/common/auth/providers/auth_state_provider.dart';
import 'package:calendy_x_project/image_upload/providers/image_uploader_provider.dart';
import 'package:calendy_x_project/polls/providers/send_meeting_poll_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// managing loading state
final isLoadingProvider = Provider<bool>(
  (ref) {
    final authState = ref.watch(authStateProvider);
    final isUploadingImage = ref.watch(imageUploaderProvider);
    final isSendingComment = ref.watch(sendCommentProvider);
    final isDeletingComment = ref.watch(deleteCommentProvider);
    final isSendingPoll = ref.watch(sendMeetingPollProvider);

    return authState.isLoading ||
        isUploadingImage ||
        isSendingComment ||
        isDeletingComment ||
        isSendingPoll;
  },
);
