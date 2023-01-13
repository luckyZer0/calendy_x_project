import 'package:calendy_x_project/tabs/group/providers/user_groups_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/animations/empty_contents_with_text_animation_view.dart';
import 'package:calendy_x_project/common/animations/error_animation.dart';
import 'package:calendy_x_project/common/animations/loading_animation.dart';
import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/tabs/group/widgets/group_tile_view.dart';

class GroupScreen extends ConsumerWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final groups = ref.watch(userGroupsProvider);
    return RefreshIndicator(
      onRefresh: () {
        ref.invalidate(userGroupsProvider);
        return Future.delayed(const Duration(seconds: 1));
      },
      child: groups.when(
        data: (groups) {
          if (groups.isEmpty) {
            return const EmptyContentWithTextAnimationView(
                text: Strings.youHaveNoGroups);
          } else {
            return GroupCardView(groups: groups);
          }
        },
        error: (error, stackTrace) => const ErrorAnimation(),
        loading: () => LoadingAnimation(isDarkMode: isDarkMode),
      ),
    );
  }
}
