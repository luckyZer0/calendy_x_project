import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:calendy_x_project/common/typedef/is_loading.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/join_group/models/join_group.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';

class JoinGroupNotifier extends StateNotifier<IsLoading> {
  JoinGroupNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Group? group;

  Future<bool> sendJoinGroup({
    required GroupId groupId,
    required UserId userId,
  }) async {
    isLoading = true;

    final joinGroupPayload = JoinGroupPayload(
      groupId: groupId,
      members: [userId],
    );
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.members)
          .where(FirebaseFieldName.groupId, isEqualTo: groupId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;

        if (doc.exists) {
          final members =
              doc.data()[FirebaseFieldName.members] as List<dynamic>;
          if (members.contains(userId)) {
            return false;
          } else {
            await doc.reference.update({
              FirebaseFieldName.members: FieldValue.arrayUnion([userId])
            });
          }
        }
      } else {
        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.members)
            .add(joinGroupPayload);
      }

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
