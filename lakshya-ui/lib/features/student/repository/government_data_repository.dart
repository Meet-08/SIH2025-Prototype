import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakshya/core/failure/app_failure.dart';
import 'package:lakshya/core/network/dio_client.dart';
import 'package:lakshya/features/student/models/college_model.dart';
import 'package:lakshya/features/student/models/scholarship_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'government_data_repository.g.dart';

@riverpod
GovernmentDataRepository governmentDataRepository(Ref ref) {
  final dioClient = ref.watch(dioProvider);
  return GovernmentDataRepository(dioClient: dioClient);
}

class GovernmentDataRepository {
  final DioClient dioClient;

  GovernmentDataRepository({required this.dioClient});

  Future<Either<AppFailure, List<CollegeModel>>> fetchColleges() async {
    try {
      final response = await dioClient.dio.get('/college');

      if (response.statusCode != 200) {
        return Left(AppFailure("Unexpected error: ${response.statusCode}"));
      }
      final List<CollegeModel> colleges = (response.data as List)
          .map((e) => CollegeModel.fromJson(e))
          .toList();
      return Right(colleges);
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

  Future<Either<AppFailure, List<ScholarshipModel>>> fetchScholarships() async {
    try {
      final response = await dioClient.dio.get('/scholarship');

      if (response.statusCode != 200) {
        return Left(AppFailure("Unexpected error: ${response.statusCode}"));
      }
      final List<ScholarshipModel> scholarships = (response.data as List)
          .map((e) => ScholarshipModel.fromJson(e))
          .toList();
      return Right(scholarships);
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
