import 'package:calendy_x_project/common/auth/providers/auth_state_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// managing loading state
final isLoadingProvider = Provider<bool>(
  (ref) {
    final authState = ref.watch(authStateProvider);
    // final isUploadingImage = ref.watch(imageUploaderProvider);
    // final isSendingComment = ref.watch(sendCommentProvider);
    // final isDeletingComment = ref.watch(deleteCommentProvider);
    // final isSendingPoll = ref.watch(sendMeetingPollProvider);

    return authState.isLoading;
  },
);
