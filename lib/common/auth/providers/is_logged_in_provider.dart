
import 'package:calendy_x_project/common/auth/models/auth_result.dart';
import 'package:calendy_x_project/common/auth/providers/auth_state_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// watch auth state provider and return a boolean 
final isLoggedInProvider = Provider<bool>(
  (ref) {
    final authState = ref.watch(authStateProvider);

    return authState.result == AuthResult.success;
  },
);
