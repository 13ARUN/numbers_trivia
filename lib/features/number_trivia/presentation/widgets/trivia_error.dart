import 'package:flutter/material.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/core/theme/theme.dart';

class TriviaError extends StatelessWidget {
  final Object error;

  const TriviaError({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    String errorMessage;
    if (error is ServerFailure) {
      errorMessage = 'Server error occurred. Please try again later.';
    } else if (error is CacheFailure) {
      errorMessage = 'No cached data found. Check your connection.';
    } else {
      errorMessage = 'An unexpected error occurred.';
    }

    return Card(
      color: AppTheme.errorColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          errorMessage,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
