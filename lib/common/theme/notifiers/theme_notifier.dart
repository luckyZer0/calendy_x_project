import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeNotifier extends StateNotifier<bool> {
  late SharedPreferences preferences;

  ThemeModeNotifier() : super(false) {
    _init();
  }

  Future _init() async {
    preferences = await SharedPreferences.getInstance();
    final darkMode = preferences.getBool("darkMode");
    state = darkMode ?? false;
  }

  void toggle() async {
    state = !state;
    preferences.setBool("darkMode", state);
  }
}
