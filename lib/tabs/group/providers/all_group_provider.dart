import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';

final allGroupProvider = StreamProvider.autoDispose<Iterable<Group>>(
  (ref) {
    final controller = StreamController<Iterable<Group>>();

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.groups)
        .orderBy(FirebaseFieldName.createdAt)
        .snapshots()
        .listen(
      (snapshot) {
        final groups = snapshot.docs.map(
          (doc) => Group(
            groupId: doc.id,
            json: doc.data(),
          ),
        );
        controller.add(groups);
      },
    );

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });
    return controller.stream;
  },
);
