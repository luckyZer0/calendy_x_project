
import 'package:calendy_x_project/common/auth/providers/auth_state_provider.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// watch the auth state provider for userId and return a userId
final userIdProvider = Provider<UserId?>(
  (ref) => ref.watch(authStateProvider).userId,
);
