import 'package:calendy_x_project/common/auth/models/auth_result.dart';
import 'package:calendy_x_project/common/typedef/is_loading.dart';
import 'package:calendy_x_project/common/typedef/user_id.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthState extends Equatable {
  final AuthResult? result;
  final IsLoading isLoading;
  final UserId? userId;

  // AuthState constructor
  const AuthState({
    required this.result,
    required this.isLoading,
    required this.userId,
  });

  // AuthState constructor for the default state
  const AuthState.unknown()
      : result = null,
        isLoading = false,
        userId = null;

  // re-use the state (basically for app performance and simplicity)
  AuthState copiedWithIsLoading(bool isLoading) => AuthState(
        result: result,
        isLoading: isLoading,
        userId: userId,
      );

  // equality (check if their hash value a is the same as hash value b, also for app performance)
  @override
  List<Object?> get props => [
        result,
        isLoading,
        userId,
      ];
}
