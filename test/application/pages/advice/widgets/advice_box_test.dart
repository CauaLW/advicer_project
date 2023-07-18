import 'package:advicer_project/application/pages/advice/widgets/advice_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  widgetUnderTest({required String adviceText}) {
    return MaterialApp(
      home: AdviceBox(advice: adviceText),
    );
  }

  group('AdviceBox', () {
    group('should be displayed correctly', () {
      testWidgets('when a short text is given', (widgetTester) async {
        const adviceText = 'A';

        await widgetTester.pumpWidget(widgetUnderTest(adviceText: adviceText));
        await widgetTester.pumpAndSettle();

        final adviceTextFinder = find.text('"$adviceText"');

        expect(adviceTextFinder, findsOneWidget);
      });
      testWidgets('when a long text is given', (widgetTester) async {
        const adviceText = 'Aliqua mollit quis officia deserunt nisi magna anim eu cupidatat. Ullamco proident ex voluptate fugiat ea dolor Lorem. Adipisicing voluptate ad do cupidatat do aliqua in velit.';

        await widgetTester.pumpWidget(widgetUnderTest(adviceText: adviceText));
        await widgetTester.pumpAndSettle();

        final adviceTextFinder = find.text('"$adviceText"');

        expect(adviceTextFinder, findsOneWidget);
      });
      testWidgets('when no text is given', (widgetTester) async {
        const adviceText = '';

        await widgetTester.pumpWidget(widgetUnderTest(adviceText: adviceText));
        await widgetTester.pumpAndSettle();

        final adviceTextFinder = find.byType(AdviceBox);

        expect(adviceTextFinder, findsOneWidget);
      });
    });
  });
}
