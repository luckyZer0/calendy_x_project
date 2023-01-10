import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:calendy_x_project/common/constants/firebase_collection_name.dart';
import 'package:calendy_x_project/common/constants/firebase_field_name.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/login/models/user_info_payload.dart';

@immutable
class UserInfoStorage {
  // const Constructor
  const UserInfoStorage();

  // user info constructor for the firebase
  Future<bool> saveUserInfo({
    required UserId userId,
    required String displayName,
    required String? email,
    required String? photoURL,
  }) async {
    try {
      // check if we have the user from before
      final userInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .where(
            FirebaseFieldName.userId,
            isEqualTo: userId,
          )
          .limit(1)
          .get();

      // update the documents in firebase
      if (userInfo.docs.isNotEmpty) {
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email ?? '',
          FirebaseFieldName.photoURL: photoURL ?? '',
        });
        return true;
      }

      // if we don't have the user's information, then create new user
      final payload = UserInfoPayload(
        userId: userId,
        displayName: displayName,
        email: email,
        photoURL: photoURL,
      );

      // store the payload data in firebase
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .add(payload);
      return true;
    } catch (e) {
      return false;
    }
  }
}