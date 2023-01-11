import 'dart:io';

import 'package:flutter/foundation.dart' show Uint8List, immutable;
import 'package:image_picker/image_picker.dart';

import 'package:calendy_x_project/image_upload/extensions/to_file.dart';

@immutable
class ImagePickerHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<File?> pickImageFromGallery() {
    return _imagePicker.pickImage(source: ImageSource.gallery).toFile();
  }

  static Future<Uint8List?> pickImageFromGalleryWeb() =>
      _imagePicker.pickImage(source: ImageSource.gallery).toFileWeb();
}
