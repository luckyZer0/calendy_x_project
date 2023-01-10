import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
          ],
        );
      },
      error: (error, stackTrace) => const ErrorAnimation(),
      loading: () => LoadingAnimation(isDarkMode: isDarkMode),
    );
  }
}
