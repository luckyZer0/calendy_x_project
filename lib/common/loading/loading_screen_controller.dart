import 'package:flutter/foundation.dart' show immutable;

// define 2 functions for close and update(takes a String value)
typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

// control the loading screen state
@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;
  
  const LoadingScreenController({
    required this.close,
    required this.update,
  });
}
