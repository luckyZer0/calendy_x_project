import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef OnTapped = void Function(int);

class BottomNavBarWidget extends ConsumerWidget {
  final Key? keys;
  final int selectedIndex;
  final OnTapped? onTapped;
  final List<BottomNavigationBarItem> items;

  const BottomNavBarWidget({
    super.key, 
    this.keys,
    required this.selectedIndex,
    this.onTapped,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(themeModeProvider);
    return BottomNavigationBar(
      key: keys,
      backgroundColor: Theme.of(context).primaryColor,
      unselectedIconTheme: IconThemeData(color: AppColors.white),
      selectedIconTheme: IconThemeData(
        color: darkMode ? AppColors.perano : AppColors.ebonyClay,
      ),
      unselectedItemColor: AppColors.white,
      selectedItemColor: darkMode ? AppColors.perano : AppColors.ebonyClay,
      currentIndex: selectedIndex,
      onTap: onTapped,
      items: items,
    );
  }
}