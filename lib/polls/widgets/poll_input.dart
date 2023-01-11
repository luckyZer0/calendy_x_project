import 'package:calendy_x_project/polls/typedefs/on_saved.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PollInput extends HookConsumerWidget {
  final String label;
  final OnSaved? onSaved;
  final bool readOnly;
  final VoidCallback? onTapped;
  final TextEditingController? controller;

  const PollInput({
    super.key,
    required this.label,
    this.onSaved,
    this.readOnly = false,
    this.onTapped,
    this.controller,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '$label is required';
        }
        return null;
      },
      onSaved: onSaved,
      onTap: onTapped,
    );
  }
}

