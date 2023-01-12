import 'package:calendy_x_project/comments/models/comment.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';
import 'package:equatable/equatable.dart';

class GroupWithComments extends Equatable {
  final Group group;
  final Iterable<Comment> comments;

  const GroupWithComments({
    required this.group,
    required this.comments,
  });

  @override
  List<Object?> get props => [
        group,
        comments,
      ];
}
