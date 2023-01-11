import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart' as material show Image;

import 'package:calendy_x_project/image_upload/extensions/get_image_aspect_ratio.dart';

extension GetImageDataAspectRatio on Uint8List {
  Future<double> getImageDataAspectRatio() {
    final image = material.Image.memory(this);
    return image.getImageAspectRatio();
  }
}
