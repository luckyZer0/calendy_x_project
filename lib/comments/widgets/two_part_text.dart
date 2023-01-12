import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class TwoPartsText extends StatelessWidget {
  final String leftPart;
  final String rightPart;

  const TwoPartsText({
    Key? key,
    required this.leftPart,
    required this.rightPart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: const TextStyle(color: Colors.white70),
        children: [
          TextSpan(
            text: ReCase(leftPart).titleCase,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ': $rightPart',
          ),
        ],
      ),
    );
  }
}
