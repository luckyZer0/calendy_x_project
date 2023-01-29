import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HorizontalLineWithText extends ConsumerWidget {
  final String label;
  final double height;
  const HorizontalLineWithText({
    super.key,
    required this.label,
    required this.height,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isDarkMode = ref.watch(themeModeProvider);
    return Row(children: <Widget>[
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 15.0),
          child: Divider(
            color: AppColors.white,
            height: height,
          ),
        ),
      ),
      Text(label),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              color: AppColors.white,
              height: height,
            )),
      ),
    ]);
  }
}
