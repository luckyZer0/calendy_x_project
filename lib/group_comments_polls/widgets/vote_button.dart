import 'dart:math';

import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/group_comments_polls/services/send_calendar_event.dart';
import 'package:calendy_x_project/login/providers/all_user_info_provider.dart';
import 'package:calendy_x_project/polls/models/meeting_poll.dart';
import 'package:calendy_x_project/polls/models/meeting_poll_comment.dart';
import 'package:calendy_x_project/polls/providers/vote_count_provider.dart';
import 'package:calendy_x_project/tabs/group/providers/user_groups_provider.dart';

class VoteButton extends ConsumerStatefulWidget {
  final bool isDarkMode;
  final MeetingPollComment pollComment;
  final MeetingPoll poll;
  final int index;
  final Iterable<MeetingPollComment> polls;
  const VoteButton({
    super.key,
    required this.isDarkMode,
    required this.pollComment,
    required this.poll,
    required this.index,
    required this.polls,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VoteButtonState();
}

// bool _buttonPressed = false;
List<bool>? _buttonPressedList;

class _VoteButtonState extends ConsumerState<VoteButton> {
  @override
  void initState() {
    super.initState();
    _buttonPressedList = List.generate(widget.polls.length, (i) => false);
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(userGroupsProvider).value;
    final userInfo =
        ref.watch(allUserInfoProvider(widget.polls.first.groupId)).value;
    return
        // !_buttonPressedList![widget.index]
        //     ?
        TextButton(
      style: widget.isDarkMode
          ? TextButton.styleFrom(
              backgroundColor: AppColors.perano,
              foregroundColor: AppColors.blackPanther,
            )
          : TextButton.styleFrom(
              backgroundColor: AppColors.ebonyClay,
              foregroundColor: AppColors.perano,
            ),
      onPressed: () async {
        //TODO: need some fixing on button visibility after tap

        int highestVoteCount = 0;

        String? highestPollId;

        List<String> tiedPollIds = [];

        final random = Random();

        // for (var user in userInfo!) {
        //   user.email;
        // }
        final emails = userInfo!.map((user) => user.email).toList();

        List<EventAttendee> attendees = emails.map((email) => EventAttendee()..email = email).toList();

        // print(emails);
        voteCount(String pollId) {
          return ref.read(voteCountProvider(pollId));
        }

        await Future.forEach(
          widget.pollComment.meetingPolls,
          (pollIds) {
            final voteCounts = voteCount(pollIds.pollId).value;
            if ([voteCounts].every((voteCount) => voteCount == 0)) {
              return;
            } else if (voteCounts! > highestVoteCount) {
              highestVoteCount = voteCounts;
              highestPollId = pollIds.pollId;
            } else if (voteCounts == highestVoteCount) {
              tiedPollIds.add(pollIds.pollId);
            }

            if (!_buttonPressedList![widget.index]) {
              // Future.delayed(const Duration(seconds: 30), () {
              setState(() {
                _buttonPressedList![widget.index] = true;
              });
              // });
            }
          },
        );

        if (tiedPollIds.isNotEmpty) {
          if (random.nextBool()) {
            tiedPollIds.shuffle(random);
            highestPollId = tiedPollIds.first;
          }
        }

        final dateTime = DateFormat.yMMMd().parse(widget.poll.date);
        final format = DateFormat.jm();
        final timeOfDay =
            TimeOfDay.fromDateTime(format.parse(widget.poll.time));

        insertGoogleCalendar(
          title: widget.pollComment.title,
          description: widget.pollComment.description,
          startDate: dateTime,
          startTime: timeOfDay,
          attendeesEmails: attendees,
        );
      },
      child: Text(
        _buttonPressedList![widget.index] ? 'Pressed' : Strings.confirmMeeting,
      ),
    )
        // : const SizedBox()
        ;
  }

  // void insertToGoogleCalendar() async {
  //   //TODO: need some fixing on button visibility after tap

  //   int highestVoteCount = 0;
  //   String? highestPollId;
  //   List<String> tiedPollIds = [];
  //   final random = Random();
  //   voteCount(String pollId) {
  //     return ref.read(voteCountProvider(pollId));
  //   }

  //   await Future.forEach(
  //     widget.pollComment.meetingPolls,
  //     (pollIds) {
  //       final voteCounts = voteCount(pollIds.pollId).value;
  //       if ([voteCounts].every((voteCount) => voteCount == 0)) {
  //         return;
  //       } else if (voteCounts! > highestVoteCount) {
  //         highestVoteCount = voteCounts;
  //         highestPollId = pollIds.pollId;
  //       } else if (voteCounts == highestVoteCount) {
  //         tiedPollIds.add(pollIds.pollId);
  //       }

  //       if (!_buttonPressedList![widget.index]) {
  //         // Future.delayed(const Duration(seconds: 30), () {
  //         setState(() {
  //           _buttonPressedList![widget.index] = true;
  //         });
  //         // });
  //       }
  //     },
  //   );

  //   if (tiedPollIds.isNotEmpty) {
  //     if (random.nextBool()) {
  //       tiedPollIds.shuffle(random);
  //       highestPollId = tiedPollIds.first;
  //     }
  //     // tiedPollIds.shuffle(random);
  //     // highestPollId = tiedPollIds.first;
  //   }

  //   final dateTime = DateFormat.yMMMd().parse(widget.poll.date);
  //   final format = DateFormat.jm();
  //   final timeOfDay = TimeOfDay.fromDateTime(format.parse(widget.poll.time));

  //   insertGoogleCalendar(
  //     title: widget.pollComment.title,
  //     description: widget.pollComment.description,
  //     startDate: dateTime,
  //     startTime: timeOfDay,
  //     // attendeesEmails: [],
  //   );
  //   // print(highestPollId);
  // }
}
