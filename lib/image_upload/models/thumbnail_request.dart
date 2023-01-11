import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

// equatable is needed because build functions need to compare the data so that the UI doesn't get call multiple times (basically it looping indefinitely and will cost app performance).
@immutable
class ThumbnailRequest extends Equatable {
  final File file;
  const ThumbnailRequest({
    required this.file,
  });

  @override
  List<Object?> get props => [
        file,
      ];
}
