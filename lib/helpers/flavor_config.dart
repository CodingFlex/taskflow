/// Single-flavor configuration for Taskflow.
///
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Flavor { single }

class FlavorValues {
  final String baseUrl;
  final String appTitle;
  final bool enableLogging;

  const FlavorValues({
    required this.baseUrl,
    this.appTitle = 'Taskflow',
    this.enableLogging = true,
  });

  factory FlavorValues.fromEnv() {
    try {
      return FlavorValues(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        appTitle: 'Taskflow',
        enableLogging: kDebugMode,
      );
    } catch (_) {
      return const FlavorValues(
        baseUrl: '',
        appTitle: 'Taskflow',
        enableLogging: true,
      );
    }
  }
}

class FlavorConfig {
  final Flavor flavor;
  final FlavorValues values;
  static FlavorConfig? _instance;

  factory FlavorConfig({FlavorValues? values}) {
    _instance ??= FlavorConfig._internal(
      Flavor.single,
      values ?? FlavorValues.fromEnv(),
    );
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.values);

  static FlavorConfig get instance {
    _instance ??= FlavorConfig();
    return _instance!;
  }

  static bool isProduction() {
    return !kDebugMode;
  }
}
