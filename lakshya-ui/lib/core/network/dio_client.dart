import 'package:dio/dio.dart';
import 'package:lakshya/core/constants/server_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

@riverpod
DioClient dio(Ref ref) {
  return DioClient();
}

class DioClient {
  final Dio dio;

  DioClient({String? baseUrl})
    : dio = Dio(
        BaseOptions(
          baseUrl: baseUrl ?? ServerConstants.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
}
