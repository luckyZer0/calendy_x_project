
import 'package:calendy_x_project/polls/models/meeting_poll.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DateTimePollNotifier extends StateNotifier<List<MeetingPoll>> {
  DateTimePollNotifier() : super([]);

  bool hasDuplicateValues(MeetingPoll poll) {
    for (MeetingPoll p in state) {
      if (p.date == poll.date && p.time == poll.time) {
        return true;
      }
    }
    return false;
  }

  void addPolls(MeetingPoll poll) {
    state = [...state, poll];
  }

  void deletePolls(MeetingPoll poll) {
    state = state.where((polls) => polls.pollId != poll.pollId).toList();
  }

  void clearPolls() {
    state = [];
  }
}
