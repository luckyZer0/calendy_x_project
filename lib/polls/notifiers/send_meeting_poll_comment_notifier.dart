import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:calendy_x_project/common/typedef/is_loading.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/polls/models/meeting_poll.dart';
import 'package:calendy_x_project/polls/models/meeting_poll_payload.dart';

class SendMeetingPollNotifier extends StateNotifier<IsLoading> {
  SendMeetingPollNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> sendMeetingComment({
    required String title,
    required UserId userId,
    required GroupId groupId,
    required List<MeetingPoll> meetingPoll,
    // required String meetingPoll,
  }) async {
    isLoading = true;

    final meetingPollCommentPayload = MeetingPollPayload(
      title: title,
      userId: userId,
      groupId: groupId,
      meetingPolls: meetingPoll,
    );

    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.meetingPoll)
          .add(meetingPollCommentPayload);
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
