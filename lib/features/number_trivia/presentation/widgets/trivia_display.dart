import 'package:flutter/material.dart';

class TriviaDisplay extends StatelessWidget {
  final int number;
  final String trivia;

  const TriviaDisplay({
    super.key,
    required this.number,
    required this.trivia,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Number: $number',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                trivia,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
