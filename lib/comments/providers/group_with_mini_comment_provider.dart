import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/comments/extensions/comment_sorting_by_request.dart';
import 'package:calendy_x_project/comments/models/comment.dart';
import 'package:calendy_x_project/comments/models/group_comment_request.dart';
import 'package:calendy_x_project/comments/models/group_with_comments.dart';
import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';

final groupWithMiniCommentProvider =
    StreamProvider.family.autoDispose<GroupWithComments, GroupCommentRequest>(
  (ref, request) {
    final controller = StreamController<GroupWithComments>();
    Group? group;
    Iterable<Comment>? comments;

    void notify() {
      final localGroup = group;

      if (localGroup == null) {
        return;
      }

      final outputComments = (comments ?? []).applySortingFromC(request);

      final result = GroupWithComments(
        group: localGroup,
        comments: outputComments,
      );

      controller.sink.add(result);
    }

    // watch for changes to the post
    final groupSub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.groups)
        .where(FieldPath.documentId, isEqualTo: request.groupId)
        .limit(1)
        .snapshots()
        .listen(
      (snapshot) {
        if (snapshot.docs.isEmpty) {
          group = null;
          comments = null;
          notify();
          return;
        }
        final doc = snapshot.docs.first;
        if (doc.metadata.hasPendingWrites) {
          return;
        }
        group = Group(
          groupId: doc.id,
          json: doc.data(),
        );
        notify();
      },
    );
    // watch for changes to the comments
    final commentsQuery = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.comments)
        .where(FirebaseFieldName.groupId, isEqualTo: request.groupId)
        .orderBy(FirebaseFieldName.createdAt, descending: true);

    final limitedCommentsQuery = request.limit != null
        ? commentsQuery.limit(request.limit!)
        : commentsQuery;

    final commentsSub = limitedCommentsQuery.snapshots().listen(
      (snapshot) {
        comments = snapshot.docs
            .where((doc) => !doc.metadata.hasPendingWrites)
            .map(
              (doc) => Comment(
                id: doc.id,
                doc.data(),
              ),
            )
            .toList();
        notify();
      },
    );

    ref.onDispose(() {
      groupSub.cancel();
      commentsSub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
