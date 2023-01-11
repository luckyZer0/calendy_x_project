import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/comments/extensions/comment_sorting_by_request.dart';
import 'package:calendy_x_project/comments/models/comment.dart';
import 'package:calendy_x_project/comments/models/group_comment_request.dart';

final groupCommentsProvider =
    StreamProvider.family.autoDispose<Iterable<Comment>, GroupCommentRequest>(
  (ref, request) {
    final controller = StreamController<Iterable<Comment>>();

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.comments)
        .where(FirebaseFieldName.groupId, isEqualTo: request.groupId)
        .snapshots()
        .listen(
      (snapshot) {
        final documents = snapshot.docs;
        final limitedDocuments =
            request.limit != null ? documents.take(request.limit!) : documents;
        final comments =
            limitedDocuments.where((doc) => !doc.metadata.hasPendingWrites).map(
                  (document) => Comment(
                    id: document.id,
                    document.data(),
                  ),
                );
        final result = comments.applySortingFromC(request);
        controller.sink.add(result);
      },
    );

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
