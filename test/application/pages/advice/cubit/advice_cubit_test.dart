import 'package:advicer_project/application/pages/advice/cubit/advice_cubit.dart';
import 'package:advicer_project/domain/entities/advice_entity.dart';
import 'package:advicer_project/domain/failures/failures.dart';
import 'package:advicer_project/domain/features/advice_feature.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAdviceFeature extends Mock implements AdviceFeature {}

void main() {
  final mockAdviceFeature = MockAdviceFeature();
  group('Advice Cubit', () {
    group('should emit', () {
      blocTest(
        'nothing when no event is added',
        build: () => AdviceCubit(adviceFeature: mockAdviceFeature),
        expect: () => <AdviceCubitState>[],
      );

      const AdviceEntity adviceForTest = AdviceEntity(advice: 'Test Advice', id: 1);
      blocTest(
        '[AdviceStateLoading, AdviceStateLoaded] when adviceRequested() is called and returns an advice',
        setUp: () {
          // Forces an Advice
          when(() => mockAdviceFeature.getAdvice()).thenAnswer(
            (realInvocation) => Future.value(
              const Right<Failure, AdviceEntity>(adviceForTest),
            ),
          );
        },
        build: () => AdviceCubit(adviceFeature: mockAdviceFeature),
        act: (cubit) => cubit.adviceRequested(),
        expect: () => <AdviceCubitState>[AdviceStateLoading(), AdviceStateLoaded(advice: adviceForTest.advice)],
      );
    });

    group('[AdviceStateLoading, AdviceStateError] when adviceRequested() is called', () {
      final serverFailure = ServerFailure();
      blocTest(
        'and returns a ServerFailure',
        setUp: () {
          // Forces an AdviceStateError
          when(() => mockAdviceFeature.getAdvice()).thenAnswer(
            (realInvocation) => Future.value(
              Left<Failure, AdviceEntity>(serverFailure),
            ),
          );
        },
        build: () => AdviceCubit(adviceFeature: mockAdviceFeature),
        act: (cubit) => cubit.adviceRequested(),
        expect: () => <AdviceCubitState>[AdviceStateLoading(), AdviceStateError(message: serverFailure.errorMessage())],
      );

      final cacheFailure = CacheFailure();
      blocTest(
        'and returns a CacheFailure',
        setUp: () {
          // Forces an AdviceStateError
          when(() => mockAdviceFeature.getAdvice()).thenAnswer(
            (realInvocation) => Future.value(
              Left<Failure, AdviceEntity>(cacheFailure),
            ),
          );
        },
        build: () => AdviceCubit(adviceFeature: mockAdviceFeature),
        act: (cubit) => cubit.adviceRequested(),
        expect: () => <AdviceCubitState>[AdviceStateLoading(), AdviceStateError(message: cacheFailure.errorMessage())],
      );

      final generalFailure = GeneralFailure();
      blocTest(
        'and returns a GeneralFailure',
        setUp: () {
          // Forces an AdviceStateError
          when(() => mockAdviceFeature.getAdvice()).thenAnswer(
            (realInvocation) => Future.value(
              Left<Failure, AdviceEntity>(generalFailure),
            ),
          );
        },
        build: () => AdviceCubit(adviceFeature: mockAdviceFeature),
        act: (cubit) => cubit.adviceRequested(),
        expect: () => <AdviceCubitState>[AdviceStateLoading(), AdviceStateError(message: generalFailure.errorMessage())],
      );
    });
  });
}
