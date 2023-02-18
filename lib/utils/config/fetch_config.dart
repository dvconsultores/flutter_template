class FetchConfig {
  // * base url
  static const String baseUrl = 'domain/api/v1';

  // * headers without auth
  static Map<String, String> headersWithoutAuth = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  /*
  // * headers with auth
  static Map<String, String> headersRightWithAut({
    String? customToken,
  }) {
    final String token =
        customToken ?? _myHiveBox.get(_HiveConfigurationDatabase.token.name);

    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    };
  }
  */
}
