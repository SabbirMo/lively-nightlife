import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';

class BaseUrl {
  BaseUrl._();

  static String get baseUrl => ApiEndpoints.baseUrl;
}

typedef ApiBaseUrl = BaseUrl;
