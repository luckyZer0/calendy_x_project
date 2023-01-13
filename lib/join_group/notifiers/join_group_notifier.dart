import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:calendy_x_project/common/typedef/is_loading.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';

enum MultiBool {
  success,
  userExists,
  error,
}

class JoinGroupNotifier extends StateNotifier<IsLoading> {
  JoinGroupNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Group? group;

  Future<MultiBool> sendJoinGroup({
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
          return MultiBool.userExists;
        } else {
          await doc.reference.set({
            FirebaseFieldName.memberId: FieldValue.arrayUnion([userId])
          }, SetOptions(merge: true));
        }
      } else {
        return MultiBool.error;
      }

      return MultiBool.success;
    } catch (_) {
      return MultiBool.error;
    } finally {
      isLoading = false;
    }
  }
}
// for subCollection
// if (doc.exists) {
      //   // create a subCollection named "members"
      //   final memberRef = docRef
      //       .collection(FirebaseCollectionName.groupMember)
      //       .doc(FirebaseCollectionName.members);

      //   // check if the member is already exist
      //   final query = await memberRef.get();

      //   if (query.exists) {
      //     final members = query.data()?[FirebaseFieldName.memberId];

      //     if (members.contains(userId)) {
      //       return MultiBool.userExists;
      //     } else {
      //       await query.reference.update({
      //         FirebaseFieldName.memberId: FieldValue.arrayUnion([userId])
      //       });
      //     }
      //   } else {
      //     await query.reference.set({
      //       FirebaseFieldName.memberId: FieldValue.arrayUnion([userId])
      //     }, SetOptions(merge: true));
      //   }
      // } else {
      //   return MultiBool.error;
      // }

// final docRef = FirebaseFirestore.instance
      //     .collection(FirebaseCollectionName.groups)
      //     .doc(groupId);
      // final doc = await docRef.get();
      // print('1: $docRef');
      // if (doc.exists) {
      //   print('2: $docRef');
      //   // create a subCollection named "members"
      //   final memberRef = docRef.collection(FirebaseCollectionName.members);
      //   // check if the userId already exist in the subCollection
      //   final querySnapshot = await memberRef.get();

      //   if (querySnapshot.docs.isEmpty) {
      //     print('3: $docRef');
      //     final addMember = await memberRef.add({
      //       FirebaseFieldName.memberId: [userId]
      //     });
      //     if (querySnapshot.docs.contains(userId)) {
      //       print('4: $docRef');
      //       return false;
      //     } else {
      //       print('5: $docRef');
      //       await addMember.set({
      //         FirebaseFieldName.memberId: FieldValue.arrayUnion([userId])
      //       }, SetOptions(merge: true));
      //     }
      //   }
      // } else {
      //   return false;
      // }

      // final doc = await FirebaseFirestore.instance
      //     .collection(FirebaseCollectionName.groups)
      //     .doc(groupId)
      //     .get();
      // if (doc.exists) {
      //   if (group!.adminId == userId) {
      //     print('admin');
      //     return false;
      //   }
      //   await doc.reference.set(
      //     {
      //       FirebaseFieldName.members: FieldValue.arrayUnion([userId])
      //     },
      //     SetOptions(merge: true),
      //   );
      // }
      // print('1: ${querySnapshot.where((element) => element.id == groupId)}');
      // if (querySnapshot.docs.contains(groupId)) {
      //   print('2: ${querySnapshot.docs} and $groupId');

      // final members =
      //     querySnapshot.docs()[FirebaseFieldName.members] as List<dynamic>;
      // print('3: ${querySnapshot.docs}');
      // if (members.contains(userId)) {
      //   print('4: ${querySnapshot.id}');
      //   return false;
      // } else {
      // print('5: ${querySnapshot.docs}');
      // await querySnapshot.reference.set({
      //   FirebaseFieldName.members: FieldValue.arrayUnion([userId])
      // });
      // }

      // }

      // if (querySnapshot.docs.isNotEmpty) {
      //   final collectionId = querySnapshot.metadata.id;

      //   if (doc.exists) {
      //     final members =
      //         doc.data()[FirebaseFieldName.members] as List<dynamic>;
      //     if (members.contains(userId)) {
      //       return false;
      //     } else {
      //       await doc.reference.update({
      //         FirebaseFieldName.members: FieldValue.arrayUnion([userId])
      //       });
      //     }
      //   }
      // } else {
      //   await FirebaseFirestore.instance
      //       .collection(FirebaseCollectionName.members)
      //       .add(joinGroupPayload);
      // }
