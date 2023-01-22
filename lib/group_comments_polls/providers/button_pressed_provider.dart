import 'package:calendy_x_project/group_comments_polls/models/button_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/group_comments_polls/models/button_state_request.dart';

final buttonPressedProvider =
    FutureProvider.family.autoDispose<bool, ButtonStateRequest>(
  (ref, request) async {
    final query = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.buttonState)
        .where(FirebaseFieldName.pollId, isEqualTo: request.pollId)
        .where(FirebaseFieldName.userId, isEqualTo: request.userId)
        .get();

    final hasButtonState =
        await query.then((snapshot) => snapshot.docs.isNotEmpty);

    if (hasButtonState) {
      try {
        await query.then((snapshot) async {
          for (final doc in snapshot.docs) {
            await doc.reference.delete();
          }
        });
        return true;
      } catch (_) {
        return false;
      }
    } else {
      final buttonState = ButtonState(
        pollId: request.pollId,
        userId: request.userId,
        buttonPressed: request.buttonPressed,
      );

      try {
        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.buttonState)
            .add(buttonState);
        return true;
      } catch (_) {
        return false;
      }
    }
  },
);
