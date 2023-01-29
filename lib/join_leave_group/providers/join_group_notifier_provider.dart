import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/typedef/is_loading.dart';
import 'package:calendy_x_project/join_leave_group/notifiers/join_group_notifier.dart';

final joinGroupNotifierProvider =
    StateNotifierProvider<JoinGroupNotifier, IsLoading>(
  (ref) => JoinGroupNotifier(),
);
