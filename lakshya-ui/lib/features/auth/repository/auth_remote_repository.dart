import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakshya/core/failure/app_failure.dart';
import 'package:lakshya/core/network/dio_client.dart';
import 'package:lakshya/features/auth/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  final dioClient = ref.watch(dioProvider);
  return AuthRemoteRepository(dioClient: dioClient);
}

class AuthRemoteRepository {
  final DioClient dioClient;

  AuthRemoteRepository({required this.dioClient});

  Future<Either<AppFailure, UserModel>> register({
    required String email,
    required String password,
    required String name,
    required int age,
    required String className,
    required String city,
  }) async {
    try {
      final response = await dioClient.dio.post(
        "/student/register",
        data: {
          "name": name,
          "email": email,
          "password": password,
          "class_name": className,
          "age": age,
          "city": city,
        },
      );

      if (response.statusCode == 201) {
        return Right(UserModel.fromJson(response.data));
      }

      return Left(AppFailure("Unexpected error: ${response.statusCode}"));
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        final detail = data["detail"] ?? "Unknown server error";
        return Left(AppFailure(detail));
      } else {
        return Left(AppFailure("Network error: ${e.message}"));
      }
    } catch (e) {
      return Left(AppFailure("Unexpected error: $e"));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        "/student/login",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        return Right(UserModel.fromJson(response.data));
      }

      return Left(AppFailure("Unexpected error: ${response.statusCode}"));
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        final detail = data["detail"] ?? "Unknown server error";
        return Left(AppFailure(detail));
      } else {
        return Left(AppFailure("Network error: ${e.message}"));
      }
    } catch (e) {
      return Left(AppFailure("Unexpected error: $e"));
    }
  }
}
