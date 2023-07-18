import 'package:advicer_project/domain/failures/failures.dart';
import 'package:advicer_project/domain/entities/advice_entity.dart';
import 'package:advicer_project/domain/repositories/advice_repo.dart';
import 'package:dartz/dartz.dart';

class AdviceFeature {
  final AdviceRepo adviceRepo;

  AdviceFeature({required this.adviceRepo});

  Future<Either<Failure, AdviceEntity>> getAdvice() async {
    return adviceRepo.getAdviceFromDataSource();
    // Space for business logic
  }
}
