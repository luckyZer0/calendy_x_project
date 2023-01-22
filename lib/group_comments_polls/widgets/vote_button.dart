import 'dart:math';

import 'package:calendy_x_project/group_comments_polls/services/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/group_comments_polls/models/button_state_request.dart';
import 'package:calendy_x_project/group_comments_polls/providers/button_pressed_provider.dart';
import 'package:calendy_x_project/group_comments_polls/providers/button_pressed_state_provider.dart';
import 'package:calendy_x_project/login/providers/all_user_info_provider.dart';
import 'package:calendy_x_project/polls/models/meeting_poll.dart';
import 'package:calendy_x_project/polls/models/meeting_poll_comment.dart';
import 'package:calendy_x_project/polls/providers/vote_count_provider.dart';
import 'package:intl/intl.dart';

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

    return TextButton(
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
              timeOfDay = TimeOfDay.fromDateTime(format.parse(pollValue.time));
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
          final buttonState = ButtonStateRequest(
            pollId: widget.pollComment.pollId,
            userId: widget.polls.first.userId,
            buttonPressed: _buttonPressed,
          );
          ref.read(buttonPressedProvider(buttonState));
        }
      },
      child: buttonStateCounter == 0
          ? const Text(Strings.confirmMeeting)
          : const Text('Undo Pressed'),
    );
    //
  }
}

// return !widget.pollComment.buttonPressed
//     ? TextButton(
//         style: widget.isDarkMode
//             ? TextButton.styleFrom(
//                 backgroundColor:
//                     buttonPressed ? AppColors.perano : AppColors.white,
//                 foregroundColor: AppColors.blackPanther,
//               )
//             : TextButton.styleFrom(
//                 backgroundColor: AppColors.ebonyClay,
//                 foregroundColor:
//                     buttonPressed ? AppColors.perano : AppColors.white,
//               ),
//         onPressed: () async {
//           //TODO: need some fixing on button visibility after tap

//           int highestVoteCount = 0;

//           String? highestPollId;

//           List<String> tiedPollIds = [];

//           final random = Random();

//           final emails = userInfo!.map((user) => user.email).toList();

//           List<EventAttendee> attendees = emails
//               .map((email) => EventAttendee()..email = email)
//               .toList();

//           voteCount(String pollId) {
//             return ref.read(voteCountProvider(pollId));
//           }

//           bool? shouldProceed;

//           for (var pollValue in widget.pollComment.meetingPolls) {
//             final voteCounts = voteCount(pollValue.pollId).value;
//             shouldProceed = [voteCounts].any((count) {
//               return count! > 0;
//             });
//             if (shouldProceed) {
//               break;
//             } else if (voteCounts! > highestVoteCount) {
//               highestVoteCount = voteCounts;
//               highestPollId = pollValue.pollId;
//             } else if (voteCounts == highestVoteCount) {
//               tiedPollIds.add(pollValue.pollId);
//             }
//           }

//           if (shouldProceed!) {
//             final buttonState = ButtonStateRequest(
//               pollId: widget.pollComment.pollId,
//               userId: widget.polls.first.userId,
//               buttonPressed: true,
//             );

//             ref.read(buttonPressedProvider(buttonState));
//             snackBar('You have 30 minutes to undo.', context);

//             Future.delayed(const Duration(minutes: 30), () {
//               final buttonState = ButtonStateRequest(
//                 pollId: widget.pollComment.pollId,
//                 userId: widget.polls.first.userId,
//                 buttonPressed: false,
//               );

//               ref.read(buttonPressedProvider(buttonState));
//               // setState(() {
//               //   _buttonNotPressedList![widget.index] = false;
//               // });
//             });
//             if (tiedPollIds.isNotEmpty) {
//               if (random.nextBool()) {
//                 tiedPollIds.shuffle(random);
//                 highestPollId = tiedPollIds.first;
//               }
//             }

//             highestPollId;

//             // final dateTime = DateFormat.yMMMd().parse(widget.poll.date);
//             // final format = DateFormat.jm();
//             // final timeOfDay =
//             //     TimeOfDay.fromDateTime(format.parse(widget.poll.time));

//             // insertGoogleCalendarEvent(
//             //   title: widget.pollComment.title,
//             //   description: widget.pollComment.description,
//             //   startDate: dateTime,
//             //   startTime: timeOfDay,
//             //   attendeesEmails: attendees,
//             //   hasConferenceSupport: true,
//             //   shouldNotifyAttendees: true,
//             // );
//           }
//         },
//         child: const Text(Strings.confirmMeeting),
//       )
//     : TextButton(
//         onPressed: () {
//           final buttonState = ButtonStateRequest(
//             pollId: widget.pollComment.pollId,
//             userId: widget.polls.first.userId,
//             buttonPressed: true,
//           );
//           print('x');
//           ref.read(buttonPressedProvider(buttonState));
//         },
//         child: const Text('Undo Pressed'),
//       );
//   },
//   loading: () => const SizedBox(),
//   error: (error, stackTrace) => const ErrorAnimation(),
// );

// return Column(
//   children: [
//     Visibility(
//       visible: buttonPressed == false,
//       child: TextButton(
//         style: widget.isDarkMode
//             ? TextButton.styleFrom(
//                 backgroundColor: AppColors.perano,
//                 foregroundColor: AppColors.blackPanther,
//               )
//             : TextButton.styleFrom(
//                 backgroundColor: AppColors.ebonyClay,
//                 foregroundColor: AppColors.perano,
//               ),
//         onPressed: () async {
//           //TODO: need some fixing on button visibility after tap

//           int highestVoteCount = 0;

//           String? highestPollId;

//           List<String> tiedPollIds = [];

//           final random = Random();

//           final emails = userInfo!.map((user) => user.email).toList();

//           List<EventAttendee> attendees = emails
//               .map((email) => EventAttendee()..email = email)
//               .toList();

//           voteCount(String pollId) {
//             return ref.read(voteCountProvider(pollId));
//           }

//           bool? shouldProceed;

//           for (var pollValue in widget.pollComment.meetingPolls) {
//             final voteCounts = voteCount(pollValue.pollId).value;
//             shouldProceed = [voteCounts].any((count) => count! > 0);
//             if (shouldProceed) {
//               break;
//             } else if (voteCounts! > highestVoteCount) {
//               highestVoteCount = voteCounts;
//               highestPollId = pollValue.pollId;
//             } else if (voteCounts == highestVoteCount) {
//               tiedPollIds.add(pollValue.pollId);
//             }
//           }

//           if (shouldProceed!) {
//             setState(() {
//               if (_buttonPressedList?[widget.index] == null) {
//                 _buttonPressedList?[widget.index] = true;
//                 _buttonNotPressedList?[widget.index] = true;
//               } else {
//                 _buttonPressedList?[widget.index] =
//                     widget.pollComment.buttonNotPressed;
//                 _buttonNotPressedList?[widget.index] =
//                     widget.pollComment.buttonNotPressed;
//               }
//             });
//             print(_buttonPressedList?[widget.index]);
//             final buttonState = ButtonStateRequest(
//               pollId: widget.pollComment.pollId,
//               userId: widget.polls.first.userId,
//               buttonPressed: true,
//               buttonNotPressed: true,
//             );

//             ref.read(buttonPressedProvider(buttonState));
//             snackBar('You have 30 minutes to undo.', context);

//             Future.delayed(const Duration(minutes: 30), () {
//               setState(() {
//                 _buttonNotPressedList![widget.index] = false;
//               });
//             });
//             if (tiedPollIds.isNotEmpty) {
//               if (random.nextBool()) {
//                 tiedPollIds.shuffle(random);
//                 highestPollId = tiedPollIds.first;
//               }
//             }

//             highestPollId;

//             // final dateTime = DateFormat.yMMMd().parse(widget.poll.date);
//             // final format = DateFormat.jm();
//             // final timeOfDay =
//             //     TimeOfDay.fromDateTime(format.parse(widget.poll.time));

//             // insertGoogleCalendarEvent(
//             //   title: widget.pollComment.title,
//             //   description: widget.pollComment.description,
//             //   startDate: dateTime,
//             //   startTime: timeOfDay,
//             //   attendeesEmails: attendees,
//             //   hasConferenceSupport: true,
//             //   shouldNotifyAttendees: true,
//             // );
//           }
//         },
//         child: const Text(Strings.confirmMeeting),
//       ),
//     ),
//     Visibility(
//       visible: buttonPressed == true,
//       child: TextButton(
//         onPressed: () {
//           setState(() {
//             // if (_buttonPressedList?[widget.index] == null) {
//             //   _buttonPressedList?[widget.index] = false;
//             //   _buttonNotPressedList?[widget.index] = false;
//             // } else {
//             //   _buttonPressedList?[widget.index] =
//             //       widget.pollComment.buttonPressed;
//             //   _buttonNotPressedList?[widget.index] =
//             //       widget.pollComment.buttonNotPressed;
//             // }
//             _buttonPressedList![widget.index] = false;
//             _buttonNotPressedList![widget.index] = false;
//           });
//           final buttonState = ButtonStateRequest(
//             pollId: widget.pollComment.pollId,
//             userId: widget.polls.first.userId,
//             buttonPressed: _buttonPressedList!.first,
//             buttonNotPressed: _buttonNotPressedList!.first,
//           );

//           ref.read(buttonPressedProvider(buttonState));
//         },
//         child: const Text('Undo Pressed'),
//       ),
//     ),
//   ],
// );
