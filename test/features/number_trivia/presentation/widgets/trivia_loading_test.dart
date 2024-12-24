import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/core/theme/theme.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/widgets/trivia_loading.dart';

void main() {
  testWidgets(
      'TriviaLoading displays CircularProgressIndicator with correct color',
      (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TriviaLoading(),
        ),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    final progressIndicator = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(progressIndicator.color, AppTheme.primaryColor);
  });

  testWidgets('TriviaLoading displays a Card and Center widget',
      (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TriviaLoading(),
        ),
      ),
    );
    // Assert
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(Center), findsOneWidget);
  });
}
