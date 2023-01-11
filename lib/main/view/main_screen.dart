import 'package:calendy_x_project/main/widgets/expandable_fab.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/auth/providers/auth_state_provider.dart';
import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/dialogs/extensions/alert_dialog_extension.dart';
import 'package:calendy_x_project/common/dialogs/logout_dialog.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/common/widgets/btm_nav_widget.dart';
import 'package:calendy_x_project/common/widgets/nav_rail_widget.dart';
import 'package:calendy_x_project/tabs/calendar/view/calendar_screen.dart';
import 'package:calendy_x_project/tabs/group/view/group_screen.dart';
import 'package:calendy_x_project/tabs/profile/view/profile_screen.dart';
import 'package:calendy_x_project/main/view_tabs/enum/tab_view_model.dart';
import 'package:calendy_x_project/main/view_tabs/provider/tab_view_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainScreen> {
  static const List<Widget> _widgets = [
    CalendarScreen(),
    GroupScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final darkMode = ref.watch(themeModeProvider);
    final tabView = ref.watch(tabViewProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(Strings.appName),
        actions: [
          IconButton(
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
            icon: darkMode
                ? const FaIcon(
                    FontAwesomeIcons.moon,
                    size: 20.0,
                  )
                : const FaIcon(
                    FontAwesomeIcons.lightbulb,
                    size: 20.0,
                  ),
          ),
          const SizedBox(width: 16.0),
          IconButton(
            onPressed: () async {
              final shouldLogout = await const LogoutDialog()
                  .present(context)
                  .then((value) => value ?? false);
              if (shouldLogout) {
                await ref.read(authStateProvider.notifier).logOut();
              }
            },
            icon: const FaIcon(
              FontAwesomeIcons.arrowRightFromBracket,
              size: 20.0,
            ),
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: Row(
        children: [
          if (MediaQuery.of(context).orientation == Orientation.landscape)
            NavRailWidget(
              selectedIndex: tabView.index,
              onTapped: (index) => ref
                  .read(tabViewProvider.notifier)
                  .update((state) => ViewTab.values[index]),
            ),
          Expanded(
            child: IndexedStack(
              index: tabView.index,
              children: _widgets,
            ),
          ),
          const VerticalDivider(
            thickness: 1.5,
            width: 1,
          )
        ],
      ),
      bottomNavigationBar: OrientationBuilder(
        builder: (context, orientation) => orientation == Orientation.portrait
            ? BottomNavBarWidget(
                selectedIndex: tabView.index,
                onTapped: (index) => ref
                    .read(tabViewProvider.notifier)
                    .update((state) => ViewTab.values[index]),
                items: const [
                  GButton(
                    icon: Icons.calendar_month,
                    text: 'Calendar',
                  ),
                  GButton(
                    icon: Icons.groups,
                    text: 'Group',
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
                  ),
                ],
              )
            : const SizedBox(),
      ),
      floatingActionButton: tabView.index == 1
          ? const ExpandableFab()
          // FloatingActionButton(
          //     backgroundColor: Theme.of(context).primaryColor,
          //     foregroundColor: AppColors.white,
          //     onPressed: () async {
          //       if (!mounted) {
          //         return;
          //       }
          //       //TODO:add dropdown list where there are twu options which is create group and join group
          //       //TODO: dont forget this
          //       // Navigator.push(
          //       //   context,
          //       //   MaterialPageRoute(
          //       //     builder: (_) => const CreateNewGroup(),
          //       //   ),
          //       // );
          //     },
          //     child: const Icon(Icons.add),
          //   )
          : null,
    );
  }
}
