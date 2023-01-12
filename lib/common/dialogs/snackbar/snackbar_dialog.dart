import 'package:flutter/material.dart';

void snackBar(String text, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }