import 'package:advicer_project/data/datasources/advice_remote_datasource.dart';
import 'package:advicer_project/data/exceptions/exceptions.dart';
import 'package:advicer_project/data/models/advice_model.dart';
import 'package:advicer_project/data/repositories/advice_repo_impl.dart';
import 'package:advicer_project/domain/entities/advice_entity.dart';
import 'package:advicer_project/domain/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'advice_repo_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AdviceRemoteDatasourceImpl>()])
void main() {
  final mockAdviceRemoteDataSource = MockAdviceRemoteDatasourceImpl();
  final adviceRepoImplUnderTest = AdviceRepoImpl(adviceRemoteDatasource: mockAdviceRemoteDataSource);
  group('AdviceRepoImpl', () {
    group('should return AdviceEntity', () {
      test('when AdviceRemoteDatasource returns a AdviceModel', () async {
        when(mockAdviceRemoteDataSource.getRandomAdviceFromApi()).thenAnswer((realInvocation) => Future.value(AdviceModel(advice: 'Test Advice', id: 1)));

        final result = await adviceRepoImplUnderTest.getAdviceFromDataSource();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(result, Right<Failure, AdviceModel>(AdviceModel(advice: 'Test Advice', id: 1)));
      });
    });
    group('should return left with', () {
      test('a ServerFailure when a ServerException Occurs', () async {
        when(mockAdviceRemoteDataSource.getRandomAdviceFromApi()).thenThrow(ServerException());

        final result = await adviceRepoImplUnderTest.getAdviceFromDataSource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, AdviceEntity>(ServerFailure()));
      });
      test('a CacheFailure when a CacheException Occurs', () async {
        when(mockAdviceRemoteDataSource.getRandomAdviceFromApi()).thenThrow(CacheException());

        final result = await adviceRepoImplUnderTest.getAdviceFromDataSource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, AdviceEntity>(CacheFailure()));
      });
      test('a GeneralFailure when other exception Occurs', () async {
        when(mockAdviceRemoteDataSource.getRandomAdviceFromApi()).thenThrow(TypeError());

        final result = await adviceRepoImplUnderTest.getAdviceFromDataSource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, AdviceEntity>(GeneralFailure()));
      });
    });
  });
}
