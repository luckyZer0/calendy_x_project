import 'package:flutter/material.dart';

import 'package:calendy_x_project/common/constants/dimensions.dart';
import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
    required this.darkMode,
    required this.screenWidth,
    required this.screenHeight,
    this.onPressed,
  }) : super(key: key);

  final bool darkMode;
  final double screenWidth;
  final double screenHeight;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: darkMode ? AppColors.perano : AppColors.ebonyClay,
        foregroundColor: darkMode ? AppColors.ebonyClay : AppColors.perano,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth / 10.0,
          vertical: screenHeight / 80.0,
        ),
        child: Text(
          Strings.loginWithGoogle,
          style: TextStyle(
            fontSize: screenWidth > mobileWidth
                ? screenHeight / 26.0
                : screenWidth / 20.0,
          ),
        ),
      ),
    );
  }
}