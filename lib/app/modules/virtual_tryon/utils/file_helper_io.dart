// Implementation for mobile platforms (iOS/Android)
import 'dart:io';

/// Create File from path on mobile platforms
/// This file is used when compiling for mobile (not web)
File createFileFromPath(String path) {
  return File(path);
}

