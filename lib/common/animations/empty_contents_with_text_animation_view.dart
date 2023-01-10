import 'package:flutter/material.dart';

import 'package:calendy_x_project/common/animations/empty_animation.dart';
import 'package:calendy_x_project/common/extensions/screen_size_extension.dart';

class EmptyContentWithTextAnimationView extends StatelessWidget {
  final String text;

  const EmptyContentWithTextAnimationView({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: context.isScreenWidth / 5.0,
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: context.isScreenWidth / 20.0,
          ),
          const EmptyAnimation(),
        ],
      ),
    );
  }
}
