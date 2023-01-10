import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/auth/providers/auth_state_provider.dart';
import 'package:calendy_x_project/common/constants/dimensions.dart';
import 'package:calendy_x_project/common/extensions/screen_size_extension.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/login/widgets/login_button.dart';
import 'package:calendy_x_project/login/widgets/logo.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = context.isScreenWidth;
    final screenHeight = context.isScreenHeight;
    final darkMode = ref.watch(themeModeProvider);
    return Material(
      color: darkMode ? AppColors.ebonyClay : AppColors.perano,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgLogo(
                paddingWidth: screenWidth / 9.0,
              ),
              SizedBox(
                height: screenWidth > mobileWidth
                    ? screenHeight / 20.0
                    : screenWidth / 10.0,
              ),
              LoginButton(
                onPressed: () =>
                    ref.read(authStateProvider.notifier).loginWithGoogle(),
                darkMode: darkMode,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              )
            ],
          ),
        ),
      ),
    );
  }
}


