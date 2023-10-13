import 'package:flutter_dotenv/flutter_dotenv.dart';

mixin _DefaultEnv {
  abstract String baseUrl;
  abstract String apiUrl;
  abstract String fileApiUrl;
}

mixin _FirebaseEnv {
  abstract String firebaseApiKey;
  abstract String firebaseAuthDomain;
  abstract String firebaseProjectId;
  abstract String firebaseStorageBucket;
  abstract String firebaseMessagingSenderId;
  abstract String firebaseAppId;
}

class AppEnv implements _DefaultEnv, _FirebaseEnv {
  // _DefaultEnv
  @override
  String baseUrl = dotenv.get('BASE_URL', fallback: "domain/api/v1");
  @override
  String apiUrl = dotenv.get('API_URL', fallback: "domain/api/v1");
  @override
  String fileApiUrl = dotenv.get('FILE_API_URL', fallback: "domain/api/v1");

  // _FirebaseEnv
  @override
  String firebaseApiKey = dotenv.get('FIREBASE_API_KEY');
  @override
  String firebaseAuthDomain = dotenv.get('FIREBASE_AUTH_DOMAIN');
  @override
  String firebaseProjectId = dotenv.get('FIREBASE_PROJECT_ID');
  @override
  String firebaseStorageBucket = dotenv.get('FIREBASE_STORAGE_BUCKET');
  @override
  String firebaseMessagingSenderId = dotenv.get('FIREBASE_MESSAGING_SENDER_ID');
  @override
  String firebaseAppId = dotenv.get('FIREBASE_APP_ID');
}

final AppEnv env = AppEnv();
