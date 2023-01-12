import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/create_new_group/view/create_new_group.dart';
import 'package:calendy_x_project/join_group/view/join_group_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({super.key});

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: AppColors.white,
      animatedIcon: AnimatedIcons.menu_close,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.group_add_rounded),
          label: 'Join a Group',
          onTap: () {
            Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const JoinGroupScreen(),
                  ),
                );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.add),
          label: 'Create a Group',
          onTap: () {
            Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateNewGroup(),
                  ),
                );
          }
        ),
      ],
    );
  }
}
