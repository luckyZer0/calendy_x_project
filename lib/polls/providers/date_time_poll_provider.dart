import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/polls/models/meeting_poll.dart';
import 'package:calendy_x_project/polls/notifiers/date_time_poll_notifier.dart';

final dateTimePollNotifierProvider =
    StateNotifierProvider.autoDispose<DateTimePollNotifier, List<MeetingPoll>>(
  (_) => DateTimePollNotifier(),
);
