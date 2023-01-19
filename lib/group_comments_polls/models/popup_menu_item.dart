import 'package:flutter/material.dart';

class PopupMenuItemData {
  final String title;
  final IconData icon;
  final Function callback;

  PopupMenuItemData({
    required this.title,
    required this.icon,
    required this.callback,
  });
}
