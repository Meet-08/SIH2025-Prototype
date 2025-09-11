import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakshya/core/failure/app_failure.dart';
import 'package:lakshya/core/network/dio_client.dart';
import 'package:lakshya/features/student/models/recommended_result_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_service.g.dart';

@riverpod
ApiService apiService(Ref ref) {
  final dioClient = ref.watch(dioProvider);
  return ApiService(dioClient: dioClient);
}

class ApiService {
  final DioClient dioClient;

  ApiService({required this.dioClient});

  Future<Either<AppFailure, RecommendationResultModel>> getRecommendation(
    Map<int, int> answers,
  ) async {
    final jsonReadyAnswers = answers.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    try {
      final response = await dioClient.dio.post(
        '/recommendation',
        data: {"answers": jsonReadyAnswers},
      );
      if (response.statusCode != 200) {
        return Left(AppFailure('Failed to fetch recommendations'));
      }
      final data = response.data;
      final recommendationResult = RecommendationResultModel.fromJson(data);
      return Right(recommendationResult);
    } catch (e) {
      return Left(AppFailure('Network error: $e'));
    }
  }
}
