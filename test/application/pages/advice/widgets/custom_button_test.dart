import 'package:advicer_project/application/pages/advice/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

abstract class CustomButtonOnTap {
  void call();
}

class MockCustomButtonOnTap extends Mock implements CustomButtonOnTap {}

void main() {
  widgetUnderTest({required String label, required void Function() onTap}) {
    return MaterialApp(
      home: Scaffold(
        body: CustomButton(label: label, onTap: onTap),
      ),
    );
  }

  group('CustomButton', () {
    group('is rendered correctly', () {
      testWidgets('and has all parts that he needs', (widgetTester) async {
        const String label = 'Get Advice';
        onTap() {}

        await widgetTester.pumpWidget(widgetUnderTest(label: label, onTap: onTap));
        await widgetTester.pumpAndSettle();

        final buttonLabelFinder = find.text(label);

        expect(buttonLabelFinder, findsOneWidget);
      });
    });
    group('should handle onTap', () {
      testWidgets('when someone has pressed the button', (widgetTester) async {
        final MockCustomButtonOnTap mockCustomButtonOnTap = MockCustomButtonOnTap();

        await widgetTester.pumpWidget(widgetUnderTest(label: 'Get Advice', onTap: mockCustomButtonOnTap));
        await widgetTester.pumpAndSettle();

        final customButtonFinder = find.byType(CustomButton);

        await widgetTester.tap(customButtonFinder);

        verify(mockCustomButtonOnTap()).called(1);
      });
    });
  });
}
