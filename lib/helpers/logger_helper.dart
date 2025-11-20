import 'package:logger/logger.dart';

/// Creates a Logger instance
Logger createLogger() {
  return Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );
}
