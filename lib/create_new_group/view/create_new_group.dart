import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/common/auth/providers/user_id_provider.dart';
import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/dialogs/snackbar/snackbar_dialog.dart';
import 'package:calendy_x_project/common/dismiss_keyboard/dismiss_keyboard.dart';
import 'package:calendy_x_project/common/extensions/screen_size_extension.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/create_new_group/widgets/create_button.dart';
import 'package:calendy_x_project/image_upload/helpers/image_picker_helper.dart';
import 'package:calendy_x_project/image_upload/providers/image_uploader_provider.dart';
import 'package:calendy_x_project/tabs/group/models/group_settings.dart';
import 'package:calendy_x_project/tabs/group/providers/group_settings_provider.dart';

class CreateNewGroup extends StatefulHookConsumerWidget {
  const CreateNewGroup({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateNewGroupState();
}

class _CreateNewGroupState extends ConsumerState<CreateNewGroup> {
  File? _imageFile;
  Future<void> onSelect() async {
    try {
      final imageFile = await ImagePickerHelper.pickImageFromGallery();
      if (imageFile == null) {
        return;
      }
      final tempImage = File(imageFile.path);

      setState(() {
        _imageFile = tempImage;
      });
    } catch (_) {
      //TODO: maybe make a more define error?
      snackBar('An Error Occurred', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);
    final screenWidth = context.isScreenWidth;
    final screenHeight = context.isScreenHeight;
    final groupSettings = ref.watch(groupSettingsProvider);
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
      child: Scaffold(
        backgroundColor:
            isDarkMode ? Theme.of(context).primaryColor : AppColors.perano,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 45, 0, 30),
                child: Text(
                  Strings.createNewGroup,
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color(Colors.black.alpha),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(120.0),
                    ),
                  ),
                ),
                onPressed: onSelect,
                child: Stack(
                  children: [
                    _imageFile == null
                        ? const CircleAvatar(
                            radius: 90,
                            child: FaIcon(
                              FontAwesomeIcons.fileImage,
                              size: 100,
                            ),
                          )
                        : CircleAvatar(
                            radius: 90,
                            backgroundImage: FileImage(_imageFile!),
                          ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                child: TextField(
                  decoration: const InputDecoration(
                      labelText: Strings.pleaseWriteYourTitleHere),
                  maxLines: null,
                  controller: textController,
                ),
              ),
              const SizedBox(height: 20.0),
              ...GroupSettings.values.map(
                (groupSetting) => ListTile(
                  title: Text(groupSetting.title),
                  subtitle: Text(groupSetting.description),
                  trailing: Switch(
                    activeColor:
                        isDarkMode ? AppColors.perano : AppColors.ebonyClay,
                    value: groupSettings[groupSetting] ?? false,
                    onChanged: (isOn) => ref
                        .read(groupSettingsProvider.notifier)
                        .setSetting(groupSetting, isOn),
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              CreateButton(
                darkMode: isDarkMode,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                onPressed: isTextButtonEnabled.value
                    ? () async {
                        try {
                          final userId = ref.read(userIdProvider);
                          if (userId == null) {
                            return;
                          }

                          if (_imageFile is String) {
                            _imageFile as File;
                          }
                          final title = textController.text.trim();
                          final isUploaded = await ref
                              .read(imageUploaderProvider.notifier)
                              .upload(
                                file: _imageFile!,
                                title: title,
                                groupSettings: groupSettings,
                                userId: userId,
                              );
                          if (isUploaded && mounted) {
                            Navigator.of(context).pop();
                          }
                        } catch (_) {
                          if (_imageFile == null) {
                            snackBar('Please select an image', context);
                          }
                        }
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
