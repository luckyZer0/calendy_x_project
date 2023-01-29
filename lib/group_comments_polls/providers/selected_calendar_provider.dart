import 'package:calendy_x_project/common/typedef/is_loading.dart';
import 'package:calendy_x_project/group_comments_polls/notifiers/selected_calendar_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedCalendarProvider =
    StateNotifierProvider<SelectedCalendarNotifier, IsLoading>(
  (ref) => SelectedCalendarNotifier(),
);