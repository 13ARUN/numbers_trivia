import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/core/usecases/usecase.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/providers/number_trivia_provider.dart';

import '../../../mocks/number_trivia_mocks.dart';



void main() {
  late MockGetConcreteNumberTrivia mockGetConcrete;
  late MockGetRandomNumberTrivia mockGetRandom;
  late MockGetCachedNumberTrivia mockGetCached;
  late TriviaNotifier notifier;

  setUpAll(() {
    registerFallbackValue(const Params(number: 1));
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockGetConcrete = MockGetConcreteNumberTrivia();
    mockGetRandom = MockGetRandomNumberTrivia();
    mockGetCached = MockGetCachedNumberTrivia();
    notifier = TriviaNotifier(mockGetConcrete, mockGetRandom, mockGetCached);
  });

  group('fetchCachedTrivia', () {
    test(
        'should set state to cached trivia when fetching cached trivia succeeds',
        () async {
      // Arrange
      const cachedTrivia = NumberTrivia(number: 1, trivia: 'Cached Trivia');
      when(() => mockGetCached.call(NoParams()))
          .thenAnswer((_) async => const Right(cachedTrivia));

      // Act
      await notifier.fetchCachedTrivia();

      // Assert
      expect(notifier.state, const AsyncValue.data(cachedTrivia));
    });

    test('should set state to default when fetching cached trivia fails',
        () async {
      // Arrange
      when(() => mockGetCached.call(NoParams()))
          .thenAnswer((_) async => Left(CacheFailure()));

      // Act
      await notifier.fetchCachedTrivia();

      // Assert
      expect(
        notifier.state,
        const AsyncValue.data(
            NumberTrivia(trivia: 'Start Seaching', number: 0)),
      );
    });
  });

  group('getConcrete', () {
    test('should return concrete trivia on success', () async {
      reset(mockGetConcrete);

      // Arrange
      const concreteTrivia = NumberTrivia(number: 42, trivia: 'Test Trivia');
      when(() => mockGetConcrete.call(const Params(number: 42)))
          .thenAnswer((_) async => const Right(concreteTrivia));

      // Act
      await notifier.getConcrete(42);

      // Assert
      expect(notifier.state, const AsyncValue.data(concreteTrivia));
    });

    test('should set state to error when getConcrete fails', () async {
      // Arrange
      when(() => mockGetConcrete.call(any()))
          .thenAnswer((_) async => Left(ServerFailure()));

      // Act
      await notifier.getConcrete(1);

      // Assert
      expect(notifier.state, isA<AsyncValue<NumberTrivia>>());
      expect(
        notifier.state,
        predicate<AsyncValue>(
            (state) => state.hasError && state.error is ServerFailure),
      );
    });
  });

  group('getRandom', () {
    test('should return random trivia on success', () async {
      // Arrange
      const randomTrivia = NumberTrivia(number: 42, trivia: 'Test Trivia');
      when(() => mockGetRandom.call(NoParams()))
          .thenAnswer((_) async => const Right(randomTrivia));

      // Act
      await notifier.getRandom();

      // Assert
      expect(notifier.state, const AsyncValue.data(randomTrivia));
    });

    test(
      'should set state to error when getRandom fails',
      () async {
        when(() => mockGetRandom.call(any()))
            .thenAnswer((_) async => Left(ServerFailure()));

        // Act
        await notifier.getRandom();

        // Assert
        expect(notifier.state, isA<AsyncValue<NumberTrivia>>());
        expect(
          notifier.state,
          predicate<AsyncValue>(
              (state) => state.hasError && state.error is ServerFailure),
        );
      },
    );
  });
}
