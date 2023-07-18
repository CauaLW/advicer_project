import 'package:advicer_project/data/datasources/advice_remote_datasource.dart';
import 'package:advicer_project/data/exceptions/exceptions.dart';
import 'package:advicer_project/domain/entities/advice_entity.dart';
import 'package:advicer_project/domain/failures/failures.dart';
import 'package:advicer_project/domain/repositories/advice_repo.dart';
import 'package:dartz/dartz.dart';

class AdviceRepoImpl implements AdviceRepo {
  final AdviceRemoteDatasource adviceRemoteDatasource;

  AdviceRepoImpl({required this.adviceRemoteDatasource});

  @override
  Future<Either<Failure, AdviceEntity>> getAdviceFromDataSource() async {
    try {
      final result = await adviceRemoteDatasource.getRandomAdviceFromApi();

      return right(result);
    } on ServerException catch (_) {
      return left(ServerFailure());
    } on CacheException catch (_) {
      return left(CacheFailure());
    } catch (_) {
      return left(GeneralFailure());
    }
  }
}
