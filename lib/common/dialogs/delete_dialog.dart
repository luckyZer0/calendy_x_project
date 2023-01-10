
import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/dialogs/extensions/alert_dialog_extension.dart';
import 'package:calendy_x_project/common/dialogs/models/alert_dialog_model.dart';
import 'package:flutter/material.dart';

@immutable
class DeleteDialog extends AlertDialogModel<bool> {
  const DeleteDialog({
    required String titleOfObjectToDelete,
  }) : super(
            title: '${Strings.delete} $titleOfObjectToDelete',
            message:
                '${Strings.areYouSureYouWantToDeleteThis} $titleOfObjectToDelete',
            buttons: const {
              Strings.cancel: false,
              Strings.delete: true,
            });
}

  Future<bool> displayDeleteDialog(BuildContext context) =>
      const DeleteDialog(titleOfObjectToDelete: Strings.comment)
          .present(context)
          .then((value) => value ?? false);