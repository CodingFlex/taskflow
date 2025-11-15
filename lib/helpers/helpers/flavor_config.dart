/// Single-flavor configuration (no multi-flavor support).
///
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Keep the minimal API surface so existing code can read `FlavorConfig.instance.values`.
enum Flavor { single }

class FlavorValues {
  // We allow fallback to dotenv for Supabase credentials if not provided in apiKeys.
  // This keeps existing usage intact while enabling direct .env reads.
  // ignore: unused_field
  final String baseUrl;
  final String appTitle;
  final bool enableLogging;
  final Map<String, String> apiKeys;

  const FlavorValues({
    this.baseUrl = '',
    this.appTitle = 'App',
    this.enableLogging = true,
    this.apiKeys = const {},
  });

  /// Get Supabase URL from apiKeys.
  /// Returns empty string if not configured.
  String get supabaseUrl {
    final fromMap = apiKeys['supabase_url']?.trim();
    if (fromMap != null && fromMap.isNotEmpty) return fromMap;
    // Fallback to .env if available
    try {
      // Import locally to avoid hard requirement during codegen or non-Flutter contexts.
      // ignore: avoid_dynamic_calls
      final env = (dotenv.env['SUPABASE_URL'] ?? '').trim();
      return env;
    } catch (_) {
      return '';
    }
  }

  /// Get Supabase anonymous key from apiKeys.
  /// Returns empty string if not configured.
  String get supabaseAnonKey {
    try {
      // ignore: avoid_dynamic_calls
      final env = (dotenv.env['SUPABASE_ANON_KEY'] ?? '').trim();
      return env;
    } catch (_) {
      return '';
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
      values ?? const FlavorValues(),
    );
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.values);

  static FlavorConfig get instance {
    _instance ??= FlavorConfig();
    return _instance!;
  }
}
