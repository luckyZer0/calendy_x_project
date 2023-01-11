import 'package:calendy_x_project/common/enums/date_sorting.dart';
import 'package:calendy_x_project/comments/models/comment.dart';
import 'package:calendy_x_project/comments/models/group_comment_request.dart';
import 'package:calendy_x_project/polls/models/meeting_poll_comment.dart';

extension SortingComment on Iterable<Comment> {
  Iterable<Comment> applySortingFromC(GroupCommentRequest request) {
    if (request.sortByCreatedAt) {
      final sortedComments = toList()
        ..sort(
          (a, b) {
            switch (request.dateSorting) {
              case DateSorting.newestOnTop:
                return b.createdAt.compareTo(a.createdAt);
              case DateSorting.oldestOnTop:
                return a.createdAt.compareTo(b.createdAt);
            }
          },
        );
      return sortedComments;
    } else {
      return this;
    }
  }
}

extension SortingMeetingPoll on Iterable<MeetingPollComment> {
  Iterable<MeetingPollComment> applySortingFromM(GroupCommentRequest request) {
    if (request.sortByCreatedAt) {
      final sortedVotes = toList()
        ..sort(
          (a, b) {
            switch (request.dateSorting) {
              case DateSorting.newestOnTop:
                return b.createdAt.compareTo(a.createdAt);
              case DateSorting.oldestOnTop:
                return a.createdAt.compareTo(b.createdAt);
            }
          },
        );
      return sortedVotes;
    } else {
      return this;
    }
  }
}
