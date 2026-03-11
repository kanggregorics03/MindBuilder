import 'package:flutter/foundation.dart';

import 'platform_backend_config_stub.dart'
    if (dart.library.io) 'platform_backend_config_io.dart';

class BackendConfig {
  static const String _override = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: '',
  );

  static String get baseUrl {
    if (_override.isNotEmpty) {
      return _override;
    }
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }
    return defaultBackendBaseUrl;
  }
}
