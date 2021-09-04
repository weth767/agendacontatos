import 'dart:io';

import 'package:flutter/material.dart';

class Utils {
  static ImageProvider recoveryContactImage(String path) {
    return FileImage(File(path));
  }
}

