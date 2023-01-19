import 'dart:async';

import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/login/models/all_user_info_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final allUserInfoProvider =
    StreamProvider.family.autoDispose<Iterable<AllUserInfoModel>, String>(
  (ref, groupId) {
    final controller = StreamController<Iterable<AllUserInfoModel>>();

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.groups)
        .doc(groupId)
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.data();
      final memberId = data![FirebaseFieldName.memberId];

      FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .where(FirebaseFieldName.userId, whereIn: memberId)
          .snapshots()
          .listen((querySnapshot) {
        final userInfoModelList = querySnapshot.docs.map((doc) {
          final json = doc.data();
          return AllUserInfoModel.fromJson(json);
        }).toList();
        controller.add(userInfoModelList);
      });
    });
    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });
    return controller.stream;
  },
);


// final allUserInfoProvider =
//     StreamProvider.family.autoDispose<Iterable<AllUserInfoModel>, String>(
//   (ref, groupId) {
//     final controller = StreamController<Iterable<AllUserInfoModel>>();

//     final groupMemberIdFuture = FirebaseFirestore.instance
//         .collection(FirebaseCollectionName.groups)
//         .doc(groupId)
//         .get()
//         .then((snapshot) {
//       final data = snapshot.data();
//       final memberId = data![FirebaseFieldName.memberId];
//       return memberId;
//     });

//     groupMemberIdFuture.then((groupMemberId) {
//       final sub = FirebaseFirestore.instance
//           .collection(FirebaseCollectionName.users)
//           .where(FirebaseFieldName.memberId, whereIn: groupMemberId)
//           .snapshots()
//           .listen((snapshot) {
//         final userInfoModelList = snapshot.docs.map((doc) {
//           final json = doc.data();
//           return AllUserInfoModel.fromJson(json);
//         }).toList();
//         controller.add(userInfoModelList);
//       });

//       ref.onDispose(() {
//         sub.cancel();
//         controller.close();
//       });
//     });

//     return controller.stream;
//   },
// );
