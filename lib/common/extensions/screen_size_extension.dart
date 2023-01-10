import 'package:flutter/material.dart' show BuildContext, MediaQuery;

extension ScreenSize on BuildContext {
  double get isScreenWidth {
    return MediaQuery.of(this).size.width;
  }
  double get isScreenHeight {
    return MediaQuery.of(this).size.height;
  }
}