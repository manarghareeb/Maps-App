import 'package:dio/dio.dart';
import 'package:maps_app/core/api/api_keys.dart';
import 'package:maps_app/core/cache/cache_helper.dart';
class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await CacheHelper().getData(key: ApiKeys.token);

    if (token != null) {
      options.headers[ApiKeys.authorization] = 'Bearer $token';
    }

    options.headers["User-Agent"] = "MapsApp/1.0 (com.example.maps_app)";
    options.headers["Content-Type"] = "application/json";
    options.headers["Accept"] = "application/json";

    super.onRequest(options, handler);
  }
}
