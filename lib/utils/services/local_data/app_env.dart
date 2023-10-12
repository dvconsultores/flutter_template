import 'package:flutter_dotenv/flutter_dotenv.dart';

mixin _DefaultEnv {
  abstract String baseUrl;
  abstract String apiUrl;
  abstract String fileApiUrl;
}

class AppEnv implements _DefaultEnv {
  @override
  String baseUrl = dotenv.get('BASE_URL', fallback: "domain/api/v1");
  @override
  String apiUrl = dotenv.get('API_URL', fallback: "domain/api/v1");
  @override
  String fileApiUrl = dotenv.get('FILE_API_URL', fallback: "domain/api/v1");
}

final AppEnv env = AppEnv();
