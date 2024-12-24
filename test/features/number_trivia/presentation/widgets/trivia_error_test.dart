import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/widgets/trivia_error.dart';

void main() {
  testWidgets('TriviaError displays correct error message for ServerFailure',
      (WidgetTester tester) async {
    // Arrange
    final error = ServerFailure();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TriviaError(error: error),
        ),
      ),
    );

    // Assert
    expect(find.text('Server error occurred. Please try again later.'),
        findsOneWidget);
  });

  testWidgets('TriviaError displays correct error message for CacheFailure',
      (WidgetTester tester) async {
    // Arrange
    final error = CacheFailure();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TriviaError(error: error),
        ),
      ),
    );

    // Assert
    expect(find.text('No cached data found. Check your connection.'),
        findsOneWidget);
  });

  testWidgets('TriviaError displays default error message for other errors',
      (WidgetTester tester) async {
    // Arrange
    final error = Exception('Some unknown error');

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TriviaError(error: error),
        ),
      ),
    );

    // Assert
    expect(find.text('An unexpected error occurred.'), findsOneWidget);
  });
}
