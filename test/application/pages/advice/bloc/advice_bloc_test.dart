import 'package:advicer_project/application/pages/advice/bloc/advice_bloc.dart';
import 'package:advicer_project/domain/entities/advice_entity.dart';
import 'package:advicer_project/domain/failures/failures.dart';
import 'package:advicer_project/domain/features/advice_feature.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../domain/features/advice_feature_test.mocks.dart';

void main() {
  final mockAdviceRepoImpl = MockAdviceRepoImpl();
  final mockAdviceFeature = AdviceFeature(adviceRepo: mockAdviceRepoImpl);
  group('Advice Bloc', () {
    group('should emits', () {
      blocTest<AdviceBloc, AdviceState>(
        'nothing when no event is added',
        build: () => AdviceBloc(adviceFeature: mockAdviceFeature),
        expect: () => <AdviceState>[],
      );

      const AdviceEntity adviceForTest = AdviceEntity(advice: 'Test Advice', id: 1);
      blocTest(
        '[AdviceStateLoading, AdviceStateLoaded] when AdviceRequestedEvent is called and returns an advice',
        setUp: () {
          // Forces an Advice
          when(mockAdviceRepoImpl.getAdviceFromDataSource()).thenAnswer(
            (realInvocation) => Future.value(
              const Right<Failure, AdviceEntity>(adviceForTest),
            ),
          );
        },
        build: () => AdviceBloc(adviceFeature: mockAdviceFeature),
        act: (bloc) => bloc.add(AdviceRequestedEvent()),
        expect: () => <AdviceState>[AdviceStateLoading(), AdviceStateLoaded(advice: adviceForTest.advice)],
      );

      group('[AdviceStateLoading, AdviceStateError] when AdviceRequestedEvent is called', () {
        final serverFailure = ServerFailure();
        blocTest(
          'and returns a ServerFailure',
          setUp: () {
            // Forces an AdviceStateError
            when(mockAdviceFeature.getAdvice()).thenAnswer(
              (realInvocation) => Future.value(
                Left<Failure, AdviceEntity>(serverFailure),
              ),
            );
          },
          build: () => AdviceBloc(adviceFeature: mockAdviceFeature),
          act: (bloc) => bloc.add(AdviceRequestedEvent()),
          expect: () => <AdviceState>[AdviceStateLoading(), AdviceStateError(message: serverFailure.errorMessage())],
        );

        final cacheFailure = CacheFailure();
        blocTest(
          'and returns a CacheFailure',
          setUp: () {
            // Forces an AdviceStateError
            when(mockAdviceFeature.getAdvice()).thenAnswer(
              (realInvocation) => Future.value(
                Left<Failure, AdviceEntity>(cacheFailure),
              ),
            );
          },
          build: () => AdviceBloc(adviceFeature: mockAdviceFeature),
          act: (bloc) => bloc.add(AdviceRequestedEvent()),
          expect: () => <AdviceState>[AdviceStateLoading(), AdviceStateError(message: cacheFailure.errorMessage())],
        );

        final generalFailure = GeneralFailure();
        blocTest(
          'and returns a GeneralFailure',
          setUp: () {
            // Forces an AdviceStateError
            when(mockAdviceFeature.getAdvice()).thenAnswer(
              (realInvocation) => Future.value(
                Left<Failure, AdviceEntity>(generalFailure),
              ),
            );
          },
          build: () => AdviceBloc(adviceFeature: mockAdviceFeature),
          act: (bloc) => bloc.add(AdviceRequestedEvent()),
          expect: () => <AdviceState>[AdviceStateLoading(), AdviceStateError(message: generalFailure.errorMessage())],
        );
      });
    });
  });
}
