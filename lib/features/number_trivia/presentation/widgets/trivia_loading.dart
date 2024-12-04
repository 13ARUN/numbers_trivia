import 'package:flutter/material.dart';
import 'package:numbers_trivia/core/theme/theme.dart';

class TriviaLoading extends StatelessWidget {
  const TriviaLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppTheme.cardHeight,
      child: const Card(
        child: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      ),
    );
  }
}
