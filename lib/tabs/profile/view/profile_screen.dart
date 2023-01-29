import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/tabs/profile/providers/profile_calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

import 'package:calendy_x_project/common/animations/error_animation.dart';
import 'package:calendy_x_project/common/animations/loading_animation.dart';
import 'package:calendy_x_project/common/auth/providers/user_id_provider.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/login/providers/user_info_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final currentUserId = ref.read(userIdProvider);
    final userInfo = ref.watch(userInfoProvider(currentUserId!));
    final getPC = ref.watch(profileCalendarProvider);
    return userInfo.when(
      data: (data) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 45, 26, 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                      child: Text(
                    ReCase(userInfo.value!.displayName).titleCase,
                    style: const TextStyle(fontSize: 24),
                  )),
                  const SizedBox(
                    width: 8.0,
                  ),
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage:
                        NetworkImage(userInfo.value!.photoURL.toString()),
                  )
                ],
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
              thickness: 2,
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: getPC.value!.length,
                  itemBuilder: (context, index) {
                    return getPC.when(
                      data: (pc) {
                        final date = DateFormat.yMMMd()
                            .format(DateTime.parse(pc.elementAt(index).date));
                        final time = pc.elementAt(index).time;
                        final dateTime = time.split("(")[1].split(")")[0];

                        final format = DateFormat.Hm();
                        final timeOfDay =
                            TimeOfDay.fromDateTime(format.parse(dateTime));

                        return Container(
                          margin: const EdgeInsets.all(16 * 0.3),
                          padding: const EdgeInsets.all(16 * 0.3),
                          decoration: BoxDecoration(
                            color: AppColors.blackPanther,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: ListTile(
                            trailing: Text(pc.elementAt(index).title),
                            title: Text(pc.elementAt(index).description),
                            subtitle: Row(
                              children: [
                                Text(date),
                                const SizedBox(width: 10),
                                Text('${timeOfDay.hour}:${timeOfDay.minute}'),
                              ],
                            ),
                          ),
                        );
                      },
                      error: (error, stackTrace) => const ErrorAnimation(),
                      loading: () => LoadingAnimation(isDarkMode: isDarkMode),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
      error: (error, stackTrace) => const ErrorAnimation(),
      loading: () => LoadingAnimation(isDarkMode: isDarkMode),
    );
  }
}
