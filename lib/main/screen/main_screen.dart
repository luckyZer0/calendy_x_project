import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/auth/providers/auth_state_provider.dart';
import 'package:calendy_x_project/common/dialogs/extensions/alert_dialog_extension.dart';
import 'package:calendy_x_project/common/dialogs/logout_dialog.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('hello world'),
          IconButton(
            onPressed: () async {
              final shouldLogout = await const LogoutDialog()
                  .present(context)
                  .then((value) => value ?? false);
              if (shouldLogout) {
                await ref.read(authStateProvider.notifier).logOut();
              }
            },
            icon: const FaIcon(
              FontAwesomeIcons.arrowRightFromBracket,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
