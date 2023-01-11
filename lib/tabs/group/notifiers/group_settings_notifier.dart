import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/tabs/group/models/group_settings.dart';

class GroupSettingsNotifier extends StateNotifier<Map<GroupSettings, bool>> {
  GroupSettingsNotifier()
      : super(
          UnmodifiableMapView(
            {
              for (final setting in GroupSettings.values) setting: true,
            },
          ),
        );

  void setSetting(
    GroupSettings setting,
    bool value,
  ) {
    final existingValue = state[setting];
    if (existingValue == null || existingValue == value) {
      return;
    }
    state = Map.unmodifiable(Map.from(state)..[setting] = value);
  }
}
