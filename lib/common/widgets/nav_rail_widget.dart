import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';

typedef OnTapped = void Function(int);

class NavRailWidget extends ConsumerWidget {
  final int selectedIndex;
  final OnTapped? onTapped;

  const NavRailWidget({
    super.key,
    required this.selectedIndex,
    this.onTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(themeModeProvider);
    return Material(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        right: false,
        child: NavigationRail(
          unselectedIconTheme: IconThemeData(color: AppColors.white),
          selectedIconTheme: IconThemeData(
            color: darkMode ? AppColors.perano : AppColors.ebonyClay,
          ),
          unselectedLabelTextStyle: TextStyle(color: AppColors.white),
          selectedLabelTextStyle: TextStyle(
              color: darkMode ? AppColors.perano : AppColors.ebonyClay),
          backgroundColor: Theme.of(context).primaryColor,
          labelType: NavigationRailLabelType.selected,
          selectedIndex: selectedIndex,
          onDestinationSelected: onTapped,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(
                Icons.calendar_month,
              ),
              label: Text(
                'Calendar',
                style: TextStyle(
                ),
              ),
            ),
            NavigationRailDestination(
              icon: Icon(
                Icons.groups,
              ),
              label: Text(
                'Group',
                style: TextStyle(
                ),
              ),
            ),
            NavigationRailDestination(
              icon: Icon(
                Icons.person,
              ),
              label: Text(
                'Profile',
                style: TextStyle(
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}