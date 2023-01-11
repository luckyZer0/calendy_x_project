import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/polls/providers/date_time_poll_provider.dart';

class PollTile extends ConsumerWidget {
  const PollTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateTimeList = ref.watch(dateTimePollNotifierProvider);
    return ListView.builder(
      itemCount: dateTimeList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          elevation: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date: ${dateTimeList[index].date}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Time: ${dateTimeList[index].time}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => ref
                    .read(dateTimePollNotifierProvider.notifier)
                    .deletePolls(dateTimeList[index]),
                icon: const Icon(Icons.delete_rounded),
              ),
            ],
          ),
        );
      },
    );
  }
}
