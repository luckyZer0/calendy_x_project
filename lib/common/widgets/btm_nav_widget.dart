import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef OnTapped = void Function(int);

class BottomNavBarWidget extends ConsumerWidget {
  final Key? keys;
  final int selectedIndex;
  final OnTapped? onTapped;
  final List<GButton> items;

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
    return Material(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: GNav(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // tabMargin: const EdgeInsets.symmetric(horizontal: 20),
          curve: Curves.easeInToLinear,
          onTabChange: onTapped,
          selectedIndex: selectedIndex,
          key: keys,
          tabBackgroundColor:
              darkMode ? AppColors.blackPanther : AppColors.white,
          backgroundColor: Theme.of(context).primaryColor,
          color: AppColors.white,
          tabs: items,
          gap: 16,
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context, WidgetRef ref) {
  //   final darkMode = ref.watch(themeModeProvider);
  //   return BottomNavigationBar(
  //     key: keys,
  //     backgroundColor: Theme.of(context).primaryColor,
  //     unselectedIconTheme: IconThemeData(color: AppColors.white),
  //     selectedIconTheme: IconThemeData(
  //       color: darkMode ? AppColors.perano : AppColors.ebonyClay,
  //     ),
  //     unselectedItemColor: AppColors.white,
  //     selectedItemColor: darkMode ? AppColors.perano : AppColors.ebonyClay,
  //     currentIndex: selectedIndex,
  //     onTap: onTapped,
  //     items: items,
  //   );
  // }
}
