
import 'package:calendy_x_project/common/auth/models/auth_state_model.dart';
import 'package:calendy_x_project/common/auth/notifiers/auth_state_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// a provider for the app to access the auth state
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (_) => AuthStateNotifier(),
);
