import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/theme/notifiers/theme_notifier.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, bool>(
  (_) => ThemeModeNotifier(),
);
