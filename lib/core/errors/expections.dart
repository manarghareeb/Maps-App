import 'package:dio/dio.dart';
import 'package:maps_app/core/errors/error_model.dart';
import 'package:maps_app/core/errors/failures.dart';

class ServerException implements Exception {
  final ErrorModel errModel;

  ServerException({required this.errModel});
  ServerFailure toFailure() => ServerFailure(errModel.errorMessage);
}

void handleDioExceptions(DioException e) {
  if (e.response != null) {
    throw ServerException(
      errModel: ErrorModel.fromJson(e.response!.data is Map 
        ? e.response!.data 
        : {'errorMessage': "Server Error", 'status': e.response!.statusCode}),
    );
  }

  String message;
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerException(errModel: ErrorModel(errorMessage: "Connection timeout"));
    case DioExceptionType.sendTimeout:
      throw ServerException(errModel: ErrorModel(errorMessage: "Send timeout"));
    case DioExceptionType.receiveTimeout:
      throw ServerException(errModel: ErrorModel(errorMessage: "Receive timeout"));
    case DioExceptionType.badCertificate:
      throw ServerException(errModel: ErrorModel(errorMessage: "Invalid SSL certificate"));
    case DioExceptionType.cancel:
      throw ServerException(errModel: ErrorModel(errorMessage: "Request cancelled"));
    case DioExceptionType.connectionError:
      throw ServerException(errModel: ErrorModel(errorMessage: "No internet connection"));
    case DioExceptionType.unknown:
      throw ServerException(errModel: ErrorModel(errorMessage: "Unexpected error occurred"));
    default: message = "Unexpected error occurred";
  }
  throw ServerException(errModel: ErrorModel(errorMessage: message, status: 500));
  
}
