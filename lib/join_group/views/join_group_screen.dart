import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/auth/providers/user_id_provider.dart';
import 'package:calendy_x_project/common/constants/dimensions.dart';
import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/dialogs/snackbar/snackbar_dialog.dart';
import 'package:calendy_x_project/common/dismiss_keyboard/dismiss_keyboard.dart';
import 'package:calendy_x_project/common/enums/multi_bool.dart';
import 'package:calendy_x_project/common/extensions/screen_size_extension.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/join_group/providers/join_group_notifier_provider.dart';
import 'package:calendy_x_project/join_group/widgets/horizontal_line_with_text.dart';

class JoinGroupScreen extends StatefulHookConsumerWidget {
  const JoinGroupScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _JoinGroupScreenState();
}

class _JoinGroupScreenState extends ConsumerState<JoinGroupScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);
    final screenWidth = context.isScreenWidth;
    final screenHeight = context.isScreenHeight;
    final textController = useTextEditingController();
    final isTextButtonEnabled = useState(false);

    useEffect(() {
      void listener() {
        isTextButtonEnabled.value = textController.text.trim().isNotEmpty;
      }

      textController.addListener(listener);

      return () {
        textController.removeListener(listener);
      };
    }, [textController]);

    return DismissKeyboardWidget(
      child: Material(
        color: isDarkMode ? Theme.of(context).primaryColor : AppColors.perano,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Text(
                Strings.joinAGroup,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: Strings.pleaseInsertGroupId,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                maxLines: null,
                controller: textController,
              ),
            ),
            const SizedBox(height: 20.0),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    isDarkMode ? AppColors.perano : AppColors.ebonyClay,
                foregroundColor:
                    isDarkMode ? AppColors.ebonyClay : AppColors.perano,
              ),
              onPressed: isTextButtonEnabled.value
                  ? () async {
                      final currentUserId = ref.read(userIdProvider);

                      await ref
                          .read(joinGroupNotifierProvider.notifier)
                          .sendJoinGroup(
                            groupId: textController.text,
                            userId: currentUserId!,
                          )
                          .then((value) {
                        if (value == MultiBool.userExists) {
                          return snackBar(
                            'You already in the Group!',
                            context,
                          );
                        } else if (value == MultiBool.error) {
                          return snackBar(
                            'Group ID does not Exist!',
                            context,
                          );
                        } else {
                          if (!mounted) return;
                          Navigator.of(context).pop();
                        }
                      });
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: Text(
                  Strings.joinGroup,
                  style: TextStyle(
                    fontSize: screenWidth > mobileWidth
                        ? screenHeight / 26.0
                        : screenWidth / 20.0,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: HorizontalLineWithText(label: 'OR', height: 10.0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      isDarkMode ? AppColors.perano : AppColors.ebonyClay,
                  foregroundColor:
                      isDarkMode ? AppColors.ebonyClay : AppColors.perano,
                ),
                onPressed: () async {
                  try {
                    final qrCode = await FlutterBarcodeScanner.scanBarcode(
                      '#ff6666',
                      'Cancel',
                      true,
                      ScanMode.QR,
                    );

                    if (!mounted) return;

                    setState(() {
                      textController.text = qrCode;
                    });
                  } catch (_) {
                    return snackBar(
                      'Group ID does not Exist!',
                      context,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'Scan QR Code',
                    style: TextStyle(
                      fontSize: screenWidth > mobileWidth
                          ? screenHeight / 26.0
                          : screenWidth / 20.0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      isDarkMode ? AppColors.perano : AppColors.ebonyClay,
                  foregroundColor:
                      isDarkMode ? AppColors.ebonyClay : AppColors.perano,
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    Strings.back,
                    style: TextStyle(
                      fontSize: screenWidth > mobileWidth
                          ? screenHeight / 26.0
                          : screenWidth / 20.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
