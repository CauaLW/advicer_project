import 'package:advicer_project/data/repositories/advice_repo_impl.dart';
import 'package:advicer_project/domain/entities/advice_entity.dart';
import 'package:advicer_project/domain/failures/failures.dart';
import 'package:advicer_project/domain/features/advice_feature.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'advice_feature_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AdviceRepoImpl>()])
void main() {
  final mockAdviceRepoImpl = MockAdviceRepoImpl();
  final adviceFeatureUnderTest = AdviceFeature(adviceRepo: mockAdviceRepoImpl);

  group('AdviceFeature', () {
    group('should return AdviceEntity', () {
      test('when AdviceRepoImpl returns an AdviceEntity', () async {
        when(mockAdviceRepoImpl.getAdviceFromDataSource()).thenAnswer(
          (realInvocation) => Future.value(
            const Right<Failure, AdviceEntity>(AdviceEntity(advice: 'Test Advice', id: 1)),
          ),
        );

        final result = await adviceFeatureUnderTest.getAdvice();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(result, const Right<Failure, AdviceEntity>(AdviceEntity(advice: 'Test Advice', id: 1)));
      });
    });
    group('should return left with', () {
      test('a ServerFailure', () async {
        when(mockAdviceRepoImpl.getAdviceFromDataSource()).thenAnswer((realInvocation) => Future.value(Left<Failure, AdviceEntity>(ServerFailure())));

        final result = await adviceFeatureUnderTest.getAdvice();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, AdviceEntity>(ServerFailure()));
      });
      test('a CacheFailure', () async {
        when(mockAdviceRepoImpl.getAdviceFromDataSource()).thenAnswer((realInvocation) => Future.value(Left<Failure, AdviceEntity>(CacheFailure())));

        final result = await adviceFeatureUnderTest.getAdvice();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, AdviceEntity>(CacheFailure()));
      });
      test('a GeneralFailure', () async {
        when(mockAdviceRepoImpl.getAdviceFromDataSource()).thenAnswer((realInvocation) => Future.value(Left<Failure, AdviceEntity>(GeneralFailure())));

        final result = await adviceFeatureUnderTest.getAdvice();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, AdviceEntity>(GeneralFailure()));
      });
    });
  });
}
