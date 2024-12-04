import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/providers/number_trivia_provider.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/widgets/trivia_error.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/widgets/trivia_loading.dart';

class NumberTriviaPage extends ConsumerStatefulWidget {
  const NumberTriviaPage({super.key});

  @override
  ConsumerState<NumberTriviaPage> createState() => _NumberTriviaPageState();
}

class _NumberTriviaPageState extends ConsumerState<NumberTriviaPage> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final triviaState = ref.watch(triviaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            triviaState.when(
              data: (trivia) => TriviaDisplay(
                number: trivia.number,
                trivia: trivia.trivia,
              ),
              loading: () => const TriviaLoading(),
              error: (error, stack) => TriviaError(
                error: error,
              ),
            ),
            const SizedBox(height: 20),
            TriviaControls(textController: _textController)
          ],
        ),
      ),
    );
  }
}
