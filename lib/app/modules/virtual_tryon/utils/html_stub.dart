// Stub file for dart:html on non-web platforms
// This file is used when dart:html is not available (iOS, Android, etc.)
// The code that uses these classes checks kIsWeb first, so these stubs never execute

// Empty stub classes to satisfy type checking
class Blob {
  Blob(List<dynamic> data);
}

class Url {
  static String createObjectUrlFromBlob(Blob blob) => '';
  static void revokeObjectUrl(String url) {}
}

class AnchorElement {
  AnchorElement({String? href});
  void setAttribute(String name, String value) {}
  void click() {}
}

