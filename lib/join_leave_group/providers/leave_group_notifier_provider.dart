import 'package:calendy_x_project/common/typedef/is_loading.dart';
import 'package:calendy_x_project/join_leave_group/notifiers/leave_group_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final leaveGroupNotifierProvider =
    StateNotifierProvider<LeaveGroupNotifier, IsLoading>(
  (ref) => LeaveGroupNotifier(),
);