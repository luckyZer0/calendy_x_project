import 'package:calendy_x_project/common/auth/models/auth_result.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';

class Authenticator {
  Authenticator();

  // get userId from firebase
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;

  //get user email from firebase
  String? get email => FirebaseAuth.instance.currentUser?.email;

  // check user login status
  bool get isAlreadyLoggedIn => userId != null;

  // get user name from firebase
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';

  // get user photoURL from firebase
  String get photoURL => FirebaseAuth.instance.currentUser?.photoURL ?? '';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      CalendarApi.calendarScope,
    ],
  );

  // calling logout function
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    // _googleSignIn.signOut();
    _googleSignIn.disconnect();
  }

  // main login function
  Future<AuthResult> loginWithGoogle() async {
    // to catch platform exception
    try {
      // check if user is not logged in
      final signInAccount = await _googleSignIn.signIn();

      if (signInAccount == null) {
        return AuthResult.aborted;
      }

      // fetch user google authentication
      final googleAuth = await signInAccount.authentication;

      // fetch user oauthCredentials
      final oauthCredentials = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(oauthCredentials);

      return AuthResult.success;
    } on PlatformException catch (_) {
      return AuthResult.aborted;
    } catch (e) {
      return AuthResult.failure;
    }
  }

  Future<CalendarApi> googleHttpClient() async {
    final signInAccount = await _googleSignIn.signIn();

    if (signInAccount != null) {
      await _googleSignIn.isSignedIn();
    }

    final httpClient = (await _googleSignIn.authenticatedClient())!;
    final CalendarApi calendarAPI = CalendarApi(httpClient);

    return calendarAPI;
  }
}