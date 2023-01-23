import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/group_comments_polls/models/button_state_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/enums/multi_bool.dart';
import 'package:calendy_x_project/common/typedef/is_loading.dart';
import 'package:calendy_x_project/polls/models/meeting_poll_comment.dart';

class ButtonPressedNotifier extends StateNotifier<IsLoading> {
  ButtonPressedNotifier() : super(false);

  set isLoading(bool value) => state = value;

  MeetingPollComment? meetingPollComment;
  Future<MultiBool> sendButtonState({
    required String pollId,
    required UserId userId,
    required bool buttonPressed,
  }) async {
    isLoading = true;

    final buttonStateRequest = ButtonStateRequest(
      pollId: pollId,
      userId: userId,
      buttonPressed: buttonPressed,
    );

    try {
      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.buttonState)
          .where(FirebaseFieldName.pollId, isEqualTo: pollId)
          .where(FirebaseFieldName.userId, isEqualTo: userId)
          .get();

      final hasButtonState =
          await query.then((snapshot) => snapshot.docs.isNotEmpty);

      if (hasButtonState) {
        await query.then((snapshot) async {
          for (final doc in snapshot.docs) {
            await doc.reference.delete();
          }
        });
      } else {
        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.buttonState)
            .add(buttonStateRequest);
      }

      return MultiBool.success;
    } catch (_) {
      return MultiBool.error;
    } finally {
      isLoading = false;
    }
  }
}
// class ButtonPressedNotifier extends StateNotifier<IsLoading> {
//   ButtonPressedNotifier() : super(false);

//   set isLoading(bool value) => state = value;

//   MeetingPollComment? meetingPollComment;
//   Future<MultiBool> sendButtonState({
//     required String pollId,
//     required UserId userId,
//     required bool buttonPressed,
//   }) async {
//     isLoading = true;
    
//     final buttonStateRequest = ButtonStateRequest(
//       pollId: pollId,
//       userId: userId,
//       buttonPressed: buttonPressed,
//     );

//     try {
//       await FirebaseFirestore.instance
//           .collection(FirebaseCollectionName.buttonState)
//           .add(buttonStateRequest);

//       return MultiBool.success;
//     } catch (_) {
//       return MultiBool.error;
//     } finally {
//       isLoading = false;
//     }
//   }
// }



// class ButtonPressedNotifier extends StateNotifier<IsLoading> {
//   ButtonPressedNotifier() : super(false);

//   set isLoading(bool value) => state = value;

//   MeetingPollComment? meetingPollComment;
//   Future<MultiBool> sendButtonState({
//     required String pollId,
//     required bool buttonPressed,
//   }) async {
//     isLoading = true;

//     try {
//       final docRef = FirebaseFirestore.instance
//           .collection(FirebaseCollectionName.meetingPoll)
//           .doc(pollId);

//       final doc = await docRef.get();

//       if (doc.exists) {
//         await doc.reference.set({
//           FirebaseFieldName.buttonStatus: {
//             "buttonPressed": buttonPressed,
//           }
//         }, SetOptions(merge: true));
//       } else {
//         return MultiBool.error;
//       }
//       return MultiBool.success;
//     } catch (_) {
//       return MultiBool.error;
//     } finally {
//       isLoading = false;
//     }
//   }
// }
