import 'package:calendy_x_project/common/typedef/is_loading.dart';
import 'package:calendy_x_project/group_comments_polls/notifiers/button_pressed_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final buttonPressedNotifierProvider =
    StateNotifierProvider<ButtonPressedNotifier, IsLoading>(
  (ref) => ButtonPressedNotifier(),
);
