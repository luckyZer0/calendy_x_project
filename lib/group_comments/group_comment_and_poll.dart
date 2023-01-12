import 'package:calendy_x_project/common/auth/providers/user_id_provider.dart';
import 'package:calendy_x_project/common/dismiss_keyboard/dismiss_keyboard.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/polls/view/meeting_poll_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:calendy_x_project/common/widgets/btm_nav_widget.dart';
import 'package:calendy_x_project/common/widgets/nav_rail_widget.dart';
import 'package:calendy_x_project/group_comments/widgets/group_comments_widget.dart';
import 'package:calendy_x_project/group_comments/widgets/group_poll_widget.dart';
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
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                //TODO: add share and delete group
              ],
            )
          ],
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
