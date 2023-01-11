import 'package:calendy_x_project/common/typedef/is_loading.dart';
import 'package:calendy_x_project/polls/notifiers/send_meeting_poll_comment_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sendMeetingPollProvider =
    StateNotifierProvider<SendMeetingPollNotifier, IsLoading>(
  (ref) => SendMeetingPollNotifier(),
);
