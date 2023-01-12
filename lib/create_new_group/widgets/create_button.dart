import 'package:flutter/material.dart';

import 'package:calendy_x_project/common/constants/dimensions.dart';
import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';

class CreateButton extends StatelessWidget {
  final bool darkMode;
  final double screenWidth;
  final double screenHeight;
  final void Function()? onPressed;
  
  const CreateButton({
    Key? key,
    required this.darkMode,
    required this.screenWidth,
    required this.screenHeight,
    this.onPressed,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: darkMode ? AppColors.perano : AppColors.white,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth / 10.0,
          vertical: screenHeight / 80.0,
        ),
        child: Text(
          Strings.createNewGroup,
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
