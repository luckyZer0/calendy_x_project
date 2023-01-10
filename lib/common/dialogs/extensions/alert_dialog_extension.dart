
import 'package:calendy_x_project/common/dialogs/models/alert_dialog_model.dart';
import 'package:flutter/material.dart';

extension Present<T> on AlertDialogModel<T> {
  Future<T?> present(BuildContext context) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: buttons.entries.map((entry) {
            return TextButton(
              onPressed: () => Navigator.of(context).pop(entry.value),
              child: Text(entry.key),
            );
          }).toList(),
        );
      },
    );
  }
}