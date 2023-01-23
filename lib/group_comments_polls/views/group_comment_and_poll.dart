import 'package:calendy_x_project/common/auth/providers/user_id_provider.dart';
import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/dialogs/delete_dialog.dart';
import 'package:calendy_x_project/common/dialogs/extensions/alert_dialog_extension.dart';
import 'package:calendy_x_project/common/dismiss_keyboard/dismiss_keyboard.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/group_comments_polls/models/popup_menu_item.dart';
import 'package:calendy_x_project/polls/view/meeting_poll_screen.dart';
import 'package:calendy_x_project/qr_code_and_scanner/view/qr_code_screen.dart';
import 'package:calendy_x_project/tabs/group/providers/delete_group_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:calendy_x_project/common/widgets/btm_nav_widget.dart';
import 'package:calendy_x_project/common/widgets/nav_rail_widget.dart';
import 'package:calendy_x_project/group_comments_polls/widgets/group_comments_widget.dart';
import 'package:calendy_x_project/group_comments_polls/widgets/group_poll_widget.dart';
import 'package:calendy_x_project/main/view_tabs/enum/tab_view_model.dart';
import 'package:calendy_x_project/main/view_tabs/provider/tab_view_provider.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';

class GroupCommentAndPoll extends StatefulHookConsumerWidget {
  final Group group;
  final GroupId groupId;
  const GroupCommentAndPoll({
    super.key,
    required this.group,
    required this.groupId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupCommentAndPollState();
}

class _GroupCommentAndPollState extends ConsumerState<GroupCommentAndPoll> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);
    final currentUserId = ref.read(userIdProvider);
    final isGroupAdmin = currentUserId == widget.group.adminId;
    final tabViewComment = ref.watch(tabViewCommentProvider);

    final List<Widget> widgets = [
      GroupCommentsView(
        group: widget.group,
        groupId: widget.groupId,
      ),
      GroupPollView(
        group: widget.group,
        groupId: widget.groupId,
      ),
    ];

    final List<PopupMenuItemData> menuItems = [
      PopupMenuItemData(
        title: 'Share Group',
        icon: Icons.share,
        callback: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QrCodeScreen(groupId: widget.group.groupId),
            ),
          );
        },
      ),
      PopupMenuItemData(
        title: 'Delete Group',
        icon: Icons.delete,
        callback: () async {
          final title = widget.group.title;
          final shouldDeleteGroup =
              await DeleteDialog(titleOfObjectToDelete: '${Strings.group}: $title')
                  .present(context)
                  .then((shouldDelete) => shouldDelete ?? false);
          if (shouldDeleteGroup) {
            await ref
                .read(deleteGroupProvider.notifier)
                .deleteGroup(group: widget.group);
            if (mounted) {
              Navigator.of(context).pop();
            }

          }
        },
      ),
    ];

    return DismissKeyboardWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  widget.group.thumbnailUrl,
                ),
              ),
              const SizedBox(width: 18.0),
              Text(widget.group.title),
            ],
          ),
          actions: isGroupAdmin
              ? [
                  PopupMenuButton(
                    onSelected: (item) => item.callback(),
                    itemBuilder: (context) => menuItems.map((item) {
                      return PopupMenuItem<PopupMenuItemData>(
                        value: item,
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              color: isDarkMode
                                  ? AppColors.white
                                  : AppColors.ebonyClay,
                            ),
                            const Spacer(),
                            Text(item.title),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                ]
              : null,
        ),
        body: Row(
          children: [
            if (MediaQuery.of(context).orientation == Orientation.landscape)
              NavRailWidget(
                selectedIndex: tabViewComment.index,
                onTapped: (index) => ref
                    .read(tabViewCommentProvider.notifier)
                    .update((state) => ViewTabComment.values[index]),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(
                      Icons.chat_rounded,
                    ),
                    label: Text(
                      'Chat',
                      style: TextStyle(),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(
                      Icons.poll_rounded,
                    ),
                    label: Text(
                      'Polls',
                      style: TextStyle(),
                    ),
                  ),
                ],
              ),
            Expanded(
              child: IndexedStack(
                index: tabViewComment.index,
                children: widgets,
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
                  selectedIndex: tabViewComment.index,
                  onTapped: (index) => ref
                      .read(tabViewCommentProvider.notifier)
                      .update((state) => ViewTabComment.values[index]),
                  items: const [
                    GButton(
                      icon: Icons.chat_rounded,
                      text: 'Chat',
                    ),
                    GButton(
                      icon: Icons.poll_rounded,
                      text: 'Polls',
                    ),
                  ],
                )
              : const SizedBox(),
        ),
        floatingActionButton: isGroupAdmin
            ? tabViewComment.index == 1
                ? FloatingActionButton(
                    // backgroundColor: Colors.blueGrey.withOpacity(0.5),
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.5),
                    foregroundColor: AppColors.white,
                    child: const FaIcon(FontAwesomeIcons.calendarPlus),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeetingPollScreen(
                            groupId: widget.groupId,
                            group: widget.group,
                          ),
                        ),
                      );
                    },
                  )
                : null
            : const SizedBox(),
      ),
    );
  }
}
