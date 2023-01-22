import 'dart:async';

import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/polls/typedefs/poll_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final buttonStatePressedProvider = StreamProvider.family.autoDispose<int, PollId>(
  (ref, pollId) {
    final controller = StreamController<int>.broadcast();

    controller.onListen = () {
      controller.sink.add(0);
    };
    
    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.buttonState)
        .where(FirebaseFieldName.pollId, isEqualTo: pollId)
        .snapshots()
        .listen(
      (snapshot) {
        controller.sink.add(snapshot.docs.length);
      },
    );
    ref.onDispose(
      () {
        sub.cancel();
        controller.close();
      },
    );

    return controller.stream;
  },
);
