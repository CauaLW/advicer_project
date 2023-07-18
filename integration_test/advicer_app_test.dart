import 'package:advicer_project/application/pages/advice/widgets/advice_box.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:advicer_project/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets(
      'tap on custom button, verify advice will be loaded',
      (widgetTester) async {
        app.main();
        await widgetTester.pumpAndSettle();

        // Verify that no advice has been loaded
        expect(find.text('Your advice is waiting for you!'), findsOneWidget);

        // Find custom button
        final customButtonFinder = find.text('Get Advice');

        // Emulate a tap on custom button
        await widgetTester.tap(customButtonFinder);

        // Trigger a frame and wait until its settled
        await widgetTester.pumpAndSettle();

        // Verify that an advice is loaded
        expect(find.byType(AdviceBox), findsOneWidget);
      },
    );
  });
}