import 'package:calendy_x_project/common/animations/lottie_animation_view.dart';
import 'package:calendy_x_project/common/animations/models/lottie_animation.dart';

class LoadingAnimation extends LottieAnimationView {
  final bool isDarkMode;
  final double? loadingWidth;
  const LoadingAnimation({
    super.key,
    this.loadingWidth,
    required this.isDarkMode,
  }) : super(
          animation: isDarkMode
              ? LottieAnimation.lightLoadingAnimation
              : LottieAnimation.darkLoadingAnimation,
        );
}
