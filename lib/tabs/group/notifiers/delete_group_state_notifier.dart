import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:calendy_x_project/common/typedef/is_loading.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeleteGroupStateNotifier extends StateNotifier<IsLoading> {
  DeleteGroupStateNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> deleteGroup({required Group group}) async {
    isLoading = true;

    try {
      // delete the post's thumbnail
      await FirebaseStorage.instance
          .ref()
          .child(group.adminId)
          .child(FirebaseCollectionName.thumbnails)
          .child(group.thumbnailStorageId)
          .delete();

      // delete the post's original file (video or image)
      await FirebaseStorage.instance
          .ref()
          .child(group.adminId)
          .child(FirebaseCollectionName.images)
          .child(group.originalFileStorageId)
          .delete();

      // delete all comments associated with this post
      await _deleteAllDocuments(
        groupId: group.groupId,
        collectionName: FirebaseCollectionName.comments,
      );

      // delete all meetings associated with this post
      await _deleteAllDocuments(
        groupId: group.groupId,
        collectionName: FirebaseCollectionName.meetingPoll,
      );

      // delete all votes associated with this post
      await _deleteAllDocuments(
        groupId: group.groupId,
        collectionName: FirebaseCollectionName.votes,
      );

      // delete all buttonStates associated with this post
      await _deleteAllDocuments(
        groupId: group.groupId,
        collectionName: FirebaseCollectionName.buttonState,
      );

      // finally delete the group itself
      final deleteGroups = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.groups)
          .where(FieldPath.documentId, isEqualTo: group.groupId)
          .limit(1)
          .get();

      for (final group in deleteGroups.docs) {
        await group.reference.delete();
      }
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _deleteAllDocuments({
    required GroupId groupId,
    required String collectionName,
  }) {
    return FirebaseFirestore.instance.runTransaction(
        maxAttempts: 3,
        timeout: const Duration(seconds: 20), (transaction) async {
      final query = await FirebaseFirestore.instance
          .collection(collectionName)
          .where(FirebaseFieldName.groupId, isEqualTo: groupId)
          .get();
      if (query.docs.isNotEmpty) {
        for (final doc in query.docs) {
          transaction.delete(doc.reference);
        }
      }
    });
  }
}
