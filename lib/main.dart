import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/auth/providers/is_logged_in_provider.dart';
import 'package:calendy_x_project/common/loading/loading_screen.dart';
import 'package:calendy_x_project/common/providers/is_loading_provider.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/common/theme/theme.dart';
import 'package:calendy_x_project/firebase_options.dart';
import 'package:calendy_x_project/login/views/login_screen.dart';
import 'package:calendy_x_project/main/screen/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: App()),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(themeModeProvider);

    return DevicePreview(
      enabled: false,
      // enabled: !kReleaseMode,
      builder: (BuildContext context) => MaterialApp(
        // useInheritedMediaQuery: true,
        title: 'Calendy',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
        home: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            ref.listen<bool>(
              isLoadingProvider,
              (_, isLoading) {
                if (isLoading) {
                  LoadingScreen.instance().show(
                    context: context,
                    bgColor: darkMode ? AppColors.jumbo : AppColors.white,
                    textColor: darkMode ? AppColors.white : AppColors.bunker,
                    cpiColor: darkMode ? AppColors.perano : AppColors.bunker,
                  );
                } else {
                  LoadingScreen.instance().hide();
                }
              },
            );
            final isLoggedIn = ref.watch(isLoggedInProvider);
            if (isLoggedIn) {
              return const MainScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
