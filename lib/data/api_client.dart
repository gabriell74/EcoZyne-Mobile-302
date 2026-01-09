import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/services/secure_storage_service.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.1.10:8000/api",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        "Accept": "application/json",
      },
    ),
  )..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final token = await SecureStorageService.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (_) {
        }

        handler.next(options);
      },

      onError: (DioException e, handler) {
        handler.next(e);
      },
    ),
  );
}
