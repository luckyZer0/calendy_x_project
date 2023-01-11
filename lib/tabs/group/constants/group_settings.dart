import 'package:calendy_x_project/tabs/group/constants/constants.dart';

enum GroupSettings {
  allowComments(
    title: Constants.allowCommentsTitle,
    description: Constants.allowCommentsDescription,
    storageKey: Constants.allowCommentsStorageKey,
  );

  final String title;
  final String description;
  final String storageKey;

  const GroupSettings({
    required this.title,
    required this.description,
    required this.storageKey,
  });
}
