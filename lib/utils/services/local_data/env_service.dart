import 'package:flutter_dotenv/flutter_dotenv.dart';

mixin _DefaultEnv {
  abstract String environment;
  abstract String apiUrl;
  abstract String deepLinkBaseUrl;
}

class Env implements _DefaultEnv {
  // _DefaultEnv
  @override
  String environment = dotenv.get('ENVIRONMENT', fallback: "development");
  @override
  String apiUrl = dotenv.get('API_URL', fallback: "domain/api/v1");
  @override
  String deepLinkBaseUrl = dotenv.get('DEEP_LINK_BASE_URL', fallback: "domain/api/v1");
}

final Env env = Env();
