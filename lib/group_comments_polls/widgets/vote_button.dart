import 'dart:math';

import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/group_comments_polls/providers/button_pressed_notifier_provider.dart';
import 'package:calendy_x_project/group_comments_polls/providers/button_pressed_state_provider.dart';
import 'package:calendy_x_project/group_comments_polls/services/calendar_event.dart';
import 'package:calendy_x_project/login/providers/all_user_info_provider.dart';
import 'package:calendy_x_project/polls/models/meeting_poll.dart';
import 'package:calendy_x_project/polls/models/meeting_poll_comment.dart';
import 'package:calendy_x_project/polls/providers/vote_count_provider.dart';

class VoteButton extends ConsumerStatefulWidget {
  final bool isDarkMode;
  final MeetingPollComment pollComment;
  final Iterable<MeetingPollComment> polls;
  final MeetingPoll poll;
  const VoteButton({
    super.key,
    required this.isDarkMode,
    required this.pollComment,
    required this.poll,
    required this.polls,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VoteButtonState();
}

class _VoteButtonState extends ConsumerState<VoteButton> {
  bool _buttonPressed = true;
  @override
  Widget build(BuildContext context) {
    final userInfo =
        ref.watch(allUserInfoProvider(widget.polls.first.groupId)).value;
    final buttonStateCounter =
        ref.watch(buttonStatePressedProvider(widget.pollComment.pollId)).value;

    return Visibility(
      visible: buttonStateCounter == 0,
      child: TextButton(
        style: widget.isDarkMode
            ? TextButton.styleFrom(
                backgroundColor: AppColors.perano,
                foregroundColor: AppColors.blackPanther,
              )
            : TextButton.styleFrom(
                backgroundColor: AppColors.ebonyClay,
                foregroundColor: AppColors.perano,
              ),
        onPressed: () {
          int highestVoteCount = 0;

          String? highestPollId;

          List<String> tiedPollIds = [];

          final random = Random();

          final emails = userInfo!.map((user) => user.email).toList();

          List<EventAttendee> attendees =
              emails.map((email) => EventAttendee()..email = email).toList();

          voteCount(String pollId) {
            return ref.read(voteCountProvider(pollId)).value;
          }

          DateTime? dateTime;
          TimeOfDay? timeOfDay;
          DateFormat? format;

          bool? shouldProceed = false;

          for (final pollValue in widget.pollComment.meetingPolls) {
            final voteCounts = voteCount(pollValue.pollId);
            if (voteCounts == null) {
              break;
            } else if (voteCounts == 0) {
              shouldProceed = true;
            } else if (voteCounts > highestVoteCount) {
              shouldProceed = true;
              highestVoteCount = voteCounts;
              highestPollId = pollValue.pollId;
            } else if (voteCounts == highestVoteCount) {
              shouldProceed = true;
              tiedPollIds.add(pollValue.pollId);
            }
          }
          if (highestPollId == null) {
            return;
          }

          if (shouldProceed!) {
            ref.read(buttonPressedNotifierProvider);
            if (tiedPollIds.isNotEmpty) {
              if (random.nextBool()) {
                tiedPollIds.shuffle(random);
                highestPollId = tiedPollIds.first;
              } else {
                highestPollId;
              }
            }

            for (final pollValue in widget.pollComment.meetingPolls) {
              if (pollValue.pollId == highestPollId) {
                dateTime = DateFormat.yMMMd().parse(pollValue.date);
                format = DateFormat.jm();
                timeOfDay =
                    TimeOfDay.fromDateTime(format.parse(pollValue.time));
              }
            }

            insertGoogleCalendarEvent(
              title: widget.pollComment.title,
              description: widget.pollComment.description,
              startDate: dateTime!,
              startTime: timeOfDay!,
              attendeesEmails: attendees,
              hasConferenceSupport: true,
              shouldNotifyAttendees: true,
            );

            _buttonPressed = !_buttonPressed;
            ref.read(buttonPressedNotifierProvider.notifier).sendButtonState(
                  pollId: widget.pollComment.pollId,
                  userId: widget.polls.first.userId,
                  buttonPressed: _buttonPressed,
                );
          }
        },
        child: buttonStateCounter == 0
            ? const Text(Strings.confirmMeeting)
            : const Text('Undo Pressed'),
      ),
    );
    //
  }
}
