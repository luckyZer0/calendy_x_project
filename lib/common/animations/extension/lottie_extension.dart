import 'package:calendy_x_project/common/animations/models/lottie_animation.dart';

extension GetFullPath on LottieAnimation {
  String get fullPath => 'assets/animations/$name.json';
}
