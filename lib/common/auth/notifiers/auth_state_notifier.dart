
import 'package:calendy_x_project/common/auth/backends/authenticator.dart';
import 'package:calendy_x_project/common/auth/models/auth_result.dart';
import 'package:calendy_x_project/common/auth/models/auth_state_model.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:calendy_x_project/login/backend/user_info_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  // private variable for authentication
  final _authenticator = Authenticator();
  final _userInfoStorage = const UserInfoStorage();

  // initialize the app state
  AuthStateNotifier() : super(const AuthState.unknown()) {
    // check if the user is logged in and set the app state
    if (_authenticator.isAlreadyLoggedIn) {
      state = AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: _authenticator.userId,
      );
    }
  }

  // logout function
  Future<void> logOut() async {
    state = state.copiedWithIsLoading(true);
    await _authenticator.logOut();
    // this unknown constructor can be interpreted as logout state
    state = const AuthState.unknown();
  }

  // login to with google info to firebase
  Future<void> loginWithGoogle() async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.loginWithGoogle();
    final userId = _authenticator.userId;

    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(userId: userId);
    }

    // set the app state
    state = AuthState(
      result: result,
      isLoading: false,
      userId: userId,
    );
  }

  // save user info function
  Future<void> saveUserInfo({required UserId userId}) =>
      _userInfoStorage.saveUserInfo(
        userId: userId,
        displayName: _authenticator.displayName,
        email: _authenticator.email,
        photoURL: _authenticator.photoURL,
      );
}