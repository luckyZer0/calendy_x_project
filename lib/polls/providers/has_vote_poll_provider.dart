import 'dart:async';

import 'package:calendy_x_project/common/auth/providers/user_id_provider.dart';
import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/polls/typedefs/poll_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final hasVotePollProvider = StreamProvider.family.autoDispose<bool, PollId>(
  (ref, pollId) {
    final userId = ref.watch(userIdProvider);

    if (userId == null) {
      return Stream<bool>.value(false);
    }

    final controller = StreamController<bool>();

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.votes)
        .where(FirebaseFieldName.pollId, isEqualTo: pollId)
        .where(FirebaseFieldName.userId, isEqualTo: userId)
        .snapshots()
        .listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          controller.add(true);
        } else {
          controller.add(false);
        }
      },
    );
    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
