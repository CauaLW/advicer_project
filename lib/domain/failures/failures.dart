import 'package:equatable/equatable.dart';

abstract class Failure {
  String errorMessage();
}

class ServerFailure extends Failure with EquatableMixin {
  @override
  String errorMessage() {
    return 'Server Failure';
  }
  
  @override
  List<Object?> get props => [];
}

class CacheFailure extends Failure with EquatableMixin {
  @override
  String errorMessage() {
    return 'Cache Failure';
  }

  @override
  List<Object?> get props => [];
}

class GeneralFailure extends Failure with EquatableMixin {
  @override
  String errorMessage() {
    return 'General Failure';
  }

  @override
  List<Object?> get props => [];
}
