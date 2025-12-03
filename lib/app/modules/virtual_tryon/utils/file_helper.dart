// Conditional export - uses file_helper_io.dart on mobile, file_helper_stub.dart on web
export 'file_helper_stub.dart' if (dart.library.io) 'file_helper_io.dart';

