enum Environment { dev, staging, prod }

class AppConfig {
  AppConfig._();

  static Environment currentEnvironment = Environment.dev;

  static String get baseUrl {
    switch (currentEnvironment) {
      case Environment.dev:
        return 'http://127.0.0.1:8000/api';
      case Environment.staging:
        return 'https://staging.modeefe.sa/api';
      case Environment.prod:
        return 'https://api.modeefe.sa/api';
    }
  }

  static const Duration connectTimeout = Duration(seconds: 3);
  static const Duration receiveTimeout = Duration(seconds: 3);
}

