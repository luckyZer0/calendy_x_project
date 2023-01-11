import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/auth/providers/user_id_provider.dart';
import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';
import 'package:calendy_x_project/tabs/group/models/group_key.dart';

final userGroupsProvider = StreamProvider.autoDispose<Iterable<Group>>(
  (ref) {
    final userId = ref.watch(userIdProvider);
    final controller = StreamController<Iterable<Group>>();

    // by default, first event get an empty array
    controller.onListen = () => controller.sink.add([]);

    // create a subscription to firebase
    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.groups)
        .orderBy(FirebaseFieldName.createdAt)
        .where(GroupKey.userId, isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      final documents = snapshot.docs;
      final groups = documents
          .where(
            (doc) => !doc.metadata.hasPendingWrites,
          )
          .map(
            (doc) => Group(
              groupId: doc.id,
              json: doc.data(),
            ),
          );

      // return the values to listener
      controller.sink.add(groups);
    });

    // basically a safeguard to cancel the subscription and close the controller
    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
