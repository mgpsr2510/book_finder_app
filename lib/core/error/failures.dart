import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
  
  String get message;
  
  @override
  List<Object> get props => [message];
}

// General failures
class ServerFailure extends Failure {
  @override
  final String message;
  
  const ServerFailure({this.message = 'Server error occurred'});
}

class NetworkFailure extends Failure {
  @override
  final String message;
  
  const NetworkFailure({this.message = 'Network error occurred'});
}

class CacheFailure extends Failure {
  @override
  final String message;
  
  const CacheFailure({this.message = 'Cache error occurred'});
}

class ValidationFailure extends Failure {
  @override
  final String message;
  
  const ValidationFailure({this.message = 'Validation error occurred'});
}

