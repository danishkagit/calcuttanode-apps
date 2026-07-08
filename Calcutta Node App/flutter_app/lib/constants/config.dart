import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kReleaseMode;

class AppConfig {
  static String get apiBaseUrl {
    if (kReleaseMode) {
      return 'https://calcuttanode-api.onrender.com/api';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api';
    }
    return 'http://localhost:5000/api';
  }

  static const String appName = 'Calcutta Node.';
  static const String email = 'calcuttanode@gmail.com';
  static const String phone = '8584885450';
  static const String address = 'Kolkata, India';
}
