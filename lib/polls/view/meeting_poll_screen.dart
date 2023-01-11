import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:calendy_x_project/common/auth/providers/user_id_provider.dart';
import 'package:calendy_x_project/common/dismiss_keyboard/dismiss_keyboard.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';
import 'package:calendy_x_project/polls/widgets/poll_button.dart';
import 'package:calendy_x_project/polls/widgets/poll_input.dart';
import 'package:calendy_x_project/polls/widgets/poll_tile.dart';
import 'package:calendy_x_project/polls/models/meeting_poll.dart';
import 'package:calendy_x_project/polls/providers/date_time_poll_provider.dart';
import 'package:calendy_x_project/polls/providers/send_meeting_poll_provider.dart';

class MeetingPollScreen extends StatefulHookConsumerWidget {
  final Group group;
  final GroupId groupId;
  const MeetingPollScreen({
    super.key,
    required this.group,
    required this.groupId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MeetingPollViewState();
}

class _MeetingPollViewState extends ConsumerState<MeetingPollScreen> {
  String? _title;
  String? _date;
  String? _time;
  final _formKey = GlobalKey<FormState>();

  void snackBar(String text) {
    var snackBar = SnackBar(
        content: Text(
      text,
      textAlign: TextAlign.center,
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final dateController = useTextEditingController();
    final timeController = useTextEditingController();
    final isDarkMode = ref.watch(themeModeProvider);
    return DismissKeyboardWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor:
            isDarkMode ? Theme.of(context).primaryColor : AppColors.white,
        appBar: AppBar(
          backgroundColor:
              isDarkMode ? AppColors.blackPanther : AppColors.perano,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                PollInput(
                  label: 'Appointment Title',
                  onSaved: (value) => _title = value,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: PollInput(
                        controller: dateController,
                        readOnly: true,
                        label: 'Date',
                        onSaved: (value) => _date = value,
                        onTapped: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 365 * 2)),
                            lastDate: DateTime.now()
                                .add(const Duration(days: 365 * 2)),
                          );

                          if (pickedDate != null) {
                            dateController.text =
                                DateFormat.yMMMd().format(pickedDate);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PollInput(
                        controller: timeController,
                        readOnly: true,
                        label: 'Time',
                        onSaved: (value) => _time = value,
                        onTapped: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (pickedTime != null && mounted) {
                            timeController.text = pickedTime.format(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: PollButton(
                        text: 'Add',
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          _formKey.currentState!.save();

                          final dateTimePoll =
                              ref.read(dateTimePollNotifierProvider.notifier);

                          if (dateTimePoll.hasDuplicateValues(
                            MeetingPoll(
                              pollId: const Uuid().v4(),
                              date: _date!,
                              time: _time!,
                            ),
                          )) {
                            snackBar('Duplicate Date and Time values');
                          } else {
                            dateTimePoll.addPolls(
                              MeetingPoll(
                                pollId: const Uuid().v4(),
                                date: _date!,
                                time: _time!,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PollButton(
                        text: 'Clear',
                        onPressed: () {
                          ref
                              .read(dateTimePollNotifierProvider.notifier)
                              .clearPolls();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PollButton(
                  text: 'Send',
                  onPressed: () async {
                    final pollData = ref.read(dateTimePollNotifierProvider);
                    final userId = ref.read(userIdProvider);
                    if (userId == null) {
                      return;
                    }

                    if (pollData.length < 2) {
                      snackBar('Need at least 2 polls');
                    } else {
                      await ref
                          .read(sendMeetingPollProvider.notifier)
                          .sendMeetingComment(
                            title: _title!,
                            userId: userId,
                            groupId: widget.groupId,
                            meetingPoll: pollData,
                          );
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Expanded(child: PollTile()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
