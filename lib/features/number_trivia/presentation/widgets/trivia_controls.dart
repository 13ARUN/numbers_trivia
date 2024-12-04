import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numbers_trivia/core/theme/theme.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/providers/number_trivia_provider.dart';

class TriviaControls extends ConsumerWidget {
  final TextEditingController textController;

  const TriviaControls({super.key, required this.textController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
                keyboardType: TextInputType.number,
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Enter a number',
                  prefixIcon: Icon(Icons.numbers),
                )),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryColor,
                    ),
                    onPressed: () {
                      ref.read(triviaProvider.notifier).getRandom();
                    },
                    icon: const Icon(Icons.shuffle),
                    label: const Text(
                      'Random',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    onPressed: () {
                      final inputNumber = int.tryParse(textController.text);
                      if (inputNumber != null) {
                        ref
                            .read(triviaProvider.notifier)
                            .getConcrete(inputNumber);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter a valid number')),
                        );
                      }
                    },
                    icon: const Icon(Icons.search),
                    label: const Text(
                      'Search',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
      ],
    );
  }
}
