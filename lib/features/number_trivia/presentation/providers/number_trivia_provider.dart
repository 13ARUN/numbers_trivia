import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/core/usecases/usecase.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_cached_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/providers/repository_providers.dart';

final triviaProvider =
    StateNotifierProvider<TriviaNotifier, AsyncValue<NumberTrivia>>((ref) {
  final getConcreteTrivia = ref.read(concreteTriviaProvider);
  final getRandomTrivia = ref.read(randomTriviaProvider);
  final getCachedTrivia = ref.read(cachedTriviaProvider);

  return TriviaNotifier(getConcreteTrivia, getRandomTrivia, getCachedTrivia);
});

class TriviaNotifier extends StateNotifier<AsyncValue<NumberTrivia>> {
  final GetConcreteNumberTrivia _getConcrete;
  final GetRandomNumberTrivia _getRandom;
  final GetCachedNumberTrivia _getCached;

  TriviaNotifier(this._getConcrete, this._getRandom, this._getCached)
      : super(const AsyncValue.loading()) {
    fetchCachedTrivia();
  }

  Future<void> fetchCachedTrivia() async {
    try {
      final result = await _getCached(NoParams());
      result.fold(
        (failure) {
          state = const AsyncValue.data(
              NumberTrivia(trivia: 'Start Seaching', number: 0));
        },
        (trivia) {
          state = AsyncValue.data(trivia);
        },
      );
    } catch (e) {
      state = AsyncValue.error(CacheFailure(), StackTrace.current);
    }
  }

  Future<void> getConcrete(int num) async {
    state = const AsyncValue.loading();
    try {
      final result = await _getConcrete(Params(number: num));
      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (trivia) => AsyncValue.data(trivia),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> getRandom() async {
    state = const AsyncValue.loading();
    try {
      final result = await _getRandom(NoParams());
      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (trivia) => AsyncValue.data(trivia),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
