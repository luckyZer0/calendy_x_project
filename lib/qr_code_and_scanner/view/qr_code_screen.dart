import 'package:calendy_x_project/common/dialogs/snackbar/snackbar_dialog.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:calendy_x_project/common/typedef/group_id.dart';

class QrCodeScreen extends ConsumerStatefulWidget {
  final GroupId groupId;
  const QrCodeScreen({
    super.key,
    required this.groupId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends ConsumerState<QrCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('QR Code/Group ID'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Text(
                'QR Code',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            QrImage(
              data: widget.groupId,
              backgroundColor: AppColors.white,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Group ID',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.groupId));
                  snackBar('Text Copied', context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.groupId,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
