import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/tabs/group/models/group_settings.dart';
import 'package:calendy_x_project/tabs/group/notifiers/group_settings_notifier.dart';

final groupSettingsProvider =
    StateNotifierProvider<GroupSettingsNotifier, Map<GroupSettings, bool>>(
  (ref) => GroupSettingsNotifier(),
);
