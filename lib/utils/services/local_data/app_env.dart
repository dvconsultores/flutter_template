import 'package:flutter_dotenv/flutter_dotenv.dart';

mixin _DefaultEnv {
  abstract String baseUrl;
  abstract String apiUrl;
  abstract String fileApiUrl;
}

// ? -- config to firebase 🖊️ --
// mixin _FirebaseEnv {
//   abstract String firebaseApiKey;
//   abstract String firebaseAuthDomain;
//   abstract String firebaseProjectId;
//   abstract String firebaseStorageBucket;
//   abstract String firebaseMessagingSenderId;
//   abstract String firebaseAppId;
// }

class AppEnv implements _DefaultEnv {
  // _DefaultEnv
  @override
  String baseUrl = dotenv.get('BASE_URL', fallback: "domain/api/v1");
  @override
  String apiUrl = dotenv.get('API_URL', fallback: "domain/api/v1");
  @override
  String fileApiUrl = dotenv.get('FILE_API_URL', fallback: "domain/api/v1");

  // ? -- config to firebase 🖊️ --
  // // _FirebaseEnv
  // @override
  // String firebaseApiKey =
  //     dotenv.get('FIREBASE_API_KEY', fallback: "firebaseApiKey");
  // @override
  // String firebaseAuthDomain =
  //     dotenv.get('FIREBASE_AUTH_DOMAIN', fallback: "firebaseAuthDomain");
  // @override
  // String firebaseProjectId =
  //     dotenv.get('FIREBASE_PROJECT_ID', fallback: "firebaseProjectId");
  // @override
  // String firebaseStorageBucket =
  //     dotenv.get('FIREBASE_STORAGE_BUCKET', fallback: "firebaseStorageBucket");
  // @override
  // String firebaseMessagingSenderId = dotenv.get('FIREBASE_MESSAGING_SENDER_ID',
  //     fallback: "firebaseMessagingSenderId");
  // @override
  // String firebaseAppId =
  //     dotenv.get('FIREBASE_APP_ID', fallback: "firebaseAppId");
}

final AppEnv env = AppEnv();
