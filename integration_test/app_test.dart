import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/screens/number_trivia_page.dart';
import 'package:numbers_trivia/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('verify home page', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(NumberTriviaPage), findsOneWidget);
    Future.delayed(const Duration(seconds: 2));
    expect(find.text('Number Trivia'), findsOneWidget);
    Future.delayed(const Duration(seconds: 2));
    await tester.enterText(find.byType(TextField), '');
  });
}
