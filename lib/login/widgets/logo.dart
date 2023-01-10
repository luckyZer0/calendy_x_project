
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SvgLogo extends ConsumerWidget {
  final double? logoWidth;
  final double paddingWidth;

  const SvgLogo({
    Key? key,
    this.logoWidth,
    required this.paddingWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(themeModeProvider);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingWidth * 0.7),
          child: SvgPicture.asset(
            darkMode
                ? 'assets/images/logo/light_logo.svg'
                : 'assets/images/logo/dark_logo.svg',
            width: logoWidth,
          ),
        ),
      ],
    );
  }
}
