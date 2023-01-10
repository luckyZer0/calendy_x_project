import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:calendy_x_project/common/animations/extension/lottie_extension.dart';
import 'package:calendy_x_project/common/animations/models/lottie_animation.dart';

class LottieAnimationView extends StatelessWidget {
  final LottieAnimation animation;
  final bool repeat;
  final bool reverse;

  const LottieAnimationView({
    Key? key,
    this.repeat = true,
    this.reverse = false,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Lottie.asset(
        animation.fullPath,
        reverse: reverse,
        repeat: repeat,
      );
}
