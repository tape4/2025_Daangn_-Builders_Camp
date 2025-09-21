import 'package:hankan/app/api/api_error.dart';

class Result<S> {
  final S? _success;
  final ApiError? _error;
  final bool isSuccess;

  Result._({S? success, ApiError? error, required this.isSuccess})
      : _success = success,
        _error = error;

  factory Result.success(S data) {
    return Result._(success: data, error: null, isSuccess: true);
  }

  factory Result.failure(ApiError error) {
    return Result._(success: null, error: error, isSuccess: false);
  }

  S get data {
    if (!isSuccess) throw Exception("Cannot get data from error result");
    return _success!;
  }

  ApiError get error {
    if (isSuccess) throw Exception("Cannot get error from success result");
    return _error!;
  }

  R fold<R>({
    required R Function(S data) onSuccess,
    required R Function(ApiError error) onFailure,
  }) {
    if (isSuccess) {
      final success = _success;
      if (success != null) return onSuccess(success);
      throw Exception('Invalid state: isSuccess is true but _success is null');
    } else {
      final error = _error;
      if (error != null) return onFailure(error);
      throw Exception('Invalid state: isSuccess is false but _error is null');
    }
  }

  Result<T> map<T>(T Function(S data) mapper) {
    if (isSuccess) {
      final success = _success;
      if (success != null) return Result.success(mapper(success));
      throw Exception('Invalid state: isSuccess is true but _success is null');
    } else {
      final error = _error;
      if (error != null) return Result.failure(error);
      throw Exception('Invalid state: isSuccess is false but _error is null');
    }
  }

  Future<Result<T>> asyncMap<T>(Future<T> Function(S data) mapper) async {
    if (isSuccess) {
      try {
        final success = _success;
        if (success != null) {
          final mapped = await mapper(success);
          return Result.success(mapped);
        }
        throw Exception(
            'Invalid state: isSuccess is true but _success is null');
      } catch (e) {
        return Result.failure(_error as ApiError);
      }
    } else {
      return Result.failure(_error!);
    }
  }
}
