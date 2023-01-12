import 'package:calendy_x_project/comments/models/comment.dart';
import 'package:calendy_x_project/comments/widgets/mini_comment_tile.dart';
import 'package:flutter/material.dart';

class SingleComment extends StatelessWidget {
  final Iterable<Comment> comments;
  const SingleComment({
    super.key,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(
        left: 0.0,
        right: 8.0,
        bottom: 8.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: comments
            .map((comment) => MiniCommentTile(comment: comment))
            .toList(),
      ),
    );
  }
}
