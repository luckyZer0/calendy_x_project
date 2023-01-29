import 'package:calendy_x_project/common/enums/multi_bool.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:calendy_x_project/common/typedef/is_loading.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';

class LeaveGroupNotifier extends StateNotifier<IsLoading> {
  LeaveGroupNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Group? group;

  Future<MultiBool> leaveGroup({
    required GroupId groupId,
    required UserId userId,
  }) async {
    isLoading = true;

    try {
      final docRef = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.groups)
          .doc(groupId);

      final doc = await docRef.get();

      if (doc.exists) {
        final members = await doc.data()?[FirebaseFieldName.memberId];
        if (members.contains(userId)) {
          await doc.reference.update({
            FirebaseFieldName.memberId: FieldValue.arrayRemove([userId])
          });
        } else {
          return MultiBool.userExists;
        }
      } else {
        return MultiBool.error;
      }

      return MultiBool.success;
    } catch (e) {
      print(e);
      return MultiBool.error;
    } finally {
      isLoading = false;
    }
  }
}
