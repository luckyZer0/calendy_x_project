import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/dialogs/extensions/alert_dialog_extension.dart';
import 'package:calendy_x_project/common/dialogs/models/alert_dialog_model.dart';
import 'package:flutter/material.dart';

@immutable
class LeaveDialog extends AlertDialogModel<bool> {
  const LeaveDialog({
    required String titleOfObject,
  }) : super(
            title: '${Strings.leave} $titleOfObject',
            message: '${Strings.leaveGroup} $titleOfObject',
            buttons: const {
              Strings.cancel: false,
              Strings.leave: true,
            });
}

Future<bool> displayLeaveDialog(BuildContext context) =>
    const LeaveDialog(titleOfObject: Strings.comment)
        .present(context)
        .then((value) => value ?? false);
