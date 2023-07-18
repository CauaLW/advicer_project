import 'package:advicer_project/domain/entities/advice_entity.dart';
import 'package:advicer_project/domain/failures/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AdviceRepo{
  Future<Either<Failure, AdviceEntity>> getAdviceFromDataSource();
}