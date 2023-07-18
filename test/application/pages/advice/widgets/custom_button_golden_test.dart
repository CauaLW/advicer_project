import 'package:advicer_project/application/pages/advice/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget widgetUnderTest({Function()? callback}) {
    return MaterialApp(
      home: Scaffold(
        body: CustomButton(label: 'label', onTap: callback),
      ),
    );
  }

  group('Golden Test', () {
    group('Custom Button', () {
      testWidgets('is enabled', (widgetTester) async {
        await widgetTester.pumpWidget(
          widgetUnderTest(
            callback: () {},
          ),
        );

        await expectLater(find.byType(CustomButton), matchesGoldenFile('goldens/custom_button_enabled.png'));
      });

      testWidgets('is disabled', (widgetTester) async {
        await widgetTester.pumpWidget(
          widgetUnderTest(),
        );

        await expectLater(find.byType(CustomButton), matchesGoldenFile('goldens/custom_button_disabled.png'));
      });
    });
  });
}
