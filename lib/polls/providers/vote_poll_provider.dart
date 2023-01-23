import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/polls/models/voter_poll.dart';
import 'package:calendy_x_project/polls/models/voter_poll_request.dart';

final votePollProvider =
    FutureProvider.family.autoDispose<bool, VoterPollRequest>(
  (ref, request) async {
    
    final query = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.votes)
        .where(FirebaseFieldName.pollId, isEqualTo: request.pollId)
        .where(FirebaseFieldName.userId, isEqualTo: request.voteBy)
        .get();

    final hasVote = await query.then((snapshot) => snapshot.docs.isNotEmpty);

    if (hasVote) {
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
      final voterPoll = VoterPoll(
        pollId: request.pollId,
        voteBy: request.voteBy,
        date: DateTime.now(), groupId: request.groupId,
      );

      try {
        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.votes)
            .add(voterPoll);
        return true;
      } catch (_) {
        return false;
      }
    }
  },
);
