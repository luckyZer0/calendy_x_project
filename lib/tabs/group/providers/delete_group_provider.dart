import 'package:calendy_x_project/common/typedef/is_loading.dart';
import 'package:calendy_x_project/tabs/group/notifiers/delete_group_state_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final deleteGroupProvider =
    StateNotifierProvider<DeleteGroupStateNotifier, IsLoading>(
  (ref) => DeleteGroupStateNotifier(),
);
