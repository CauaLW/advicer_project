import 'package:advicer_project/application/core/services/theme_service.dart';
import 'package:advicer_project/application/pages/advice/advice_page.dart';
import 'package:advicer_project/application/pages/advice/cubit/advice_cubit.dart';
import 'package:advicer_project/application/pages/advice/widgets/advice_box.dart';
import 'package:advicer_project/application/pages/advice/widgets/error_message.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class MockAdviceCubit extends MockCubit<AdviceCubitState> implements AdviceCubit {}

void main() {
  widgetUnderTest({required AdviceCubit cubit}) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => ThemeService(),
        child: BlocProvider<AdviceCubit>(
          create: (context) => cubit,
          child: const AdvicePage(),
        ),
      ),
    );
  }

  group('AdvicePage', () {
    late AdviceCubit mockAdviceCubit;
    setUp(() {
      mockAdviceCubit = MockAdviceCubit();
    });
    group('should be displayed in ViewState', () {
      testWidgets('Initial when cubit emits AdviceInitialState()', (widgetTester) async {
        whenListen(
          mockAdviceCubit,
          Stream.fromIterable([AdviceInitialState()]),
          initialState: AdviceInitialState(),
        );

        await widgetTester.pumpWidget(widgetUnderTest(cubit: mockAdviceCubit));

        final adviceInitialTextFinder = find.text('Your advice is waiting for you!');

        expect(adviceInitialTextFinder, findsOneWidget);
      });
      testWidgets('Loading when cubit emits AdviceStateLoading()', (widgetTester) async {
        whenListen(
          mockAdviceCubit,
          Stream.fromIterable([AdviceStateLoading()]),
          initialState: AdviceInitialState(),
        );

        await widgetTester.pumpWidget(widgetUnderTest(cubit: mockAdviceCubit));
        // pumpAndSettle will not work, because the loader is a constant animation
        // so the pumpAndSettle will try to await for an infinte animation to end
        await widgetTester.pump();

        final adviceLoaderFinder = find.byType(CircularProgressIndicator);

        expect(adviceLoaderFinder, findsOneWidget);
      });
      testWidgets('Advice text when cubit emits AdviceStateLoaded()', (widgetTester) async {
        const String testAdvice = 'Advice for testing';
        whenListen(
          mockAdviceCubit,
          Stream.fromIterable(const [AdviceStateLoaded(advice: testAdvice)]),
          initialState: AdviceInitialState(),
        );

        await widgetTester.pumpWidget(widgetUnderTest(cubit: mockAdviceCubit));
        await widgetTester.pumpAndSettle();

        final adviceBoxFinder = find.byType(AdviceBox);
        final adviceText = widgetTester.widget<AdviceBox>(adviceBoxFinder).advice;

        expect(adviceBoxFinder, findsOneWidget);
        expect(adviceText, testAdvice);
      });
      testWidgets('Error when cubit emits AdviceStateError()', (widgetTester) async {
        const String testError = 'Error for testing';
        whenListen(
          mockAdviceCubit,
          Stream.fromIterable(const [AdviceStateError(message: testError)]),
          initialState: AdviceInitialState(),
        );

        await widgetTester.pumpWidget(widgetUnderTest(cubit: mockAdviceCubit));
        await widgetTester.pumpAndSettle();

        final adviceErrorMessageFinder = find.byType(ErrorMessage);
        final errorText = widgetTester.widget<ErrorMessage>(adviceErrorMessageFinder).message;

        expect(adviceErrorMessageFinder, findsOneWidget);
        expect(errorText, testError);
      });
    });
  });
}
