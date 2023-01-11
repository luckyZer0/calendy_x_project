import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:calendy_x_project/common/enums/date_sorting.dart';
import 'package:calendy_x_project/common/typedef/group_id.dart';
import 'package:calendy_x_project/tabs/group/models/group.dart';

@immutable
class GroupCommentRequest extends Equatable {
  final Group? group;
  final GroupId groupId;
  final bool sortByCreatedAt;
  final DateSorting dateSorting;
  final int? limit;

  const GroupCommentRequest({
    this.group,
    required this.groupId,
    this.sortByCreatedAt = true,
    this.dateSorting = DateSorting.oldestOnTop,
    this.limit,
  });

  @override
  List<Object?> get props => [
        groupId,
        sortByCreatedAt,
        dateSorting,
        limit,
      ];
}
