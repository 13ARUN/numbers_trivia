import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // Use mocktail package
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/core/usecases/usecase.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_cached_number_trivia.dart';

import '../../../../core/mocks/number_trivia_mocks.dart';

void main() {
  late GetCachedNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetCachedNumberTrivia(repository: mockNumberTriviaRepository);

    // Register the mocktail fallback for the NumberTriviaRepository method
    registerFallbackValue(const NumberTrivia(number: 1, trivia: 'test'));
  });

  const tNumberTrivia = NumberTrivia(number: 1, trivia: 'test');

  test('should get cached trivia from the repository', () async {
    // Arrange
    when(() => mockNumberTriviaRepository.getCachedTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));
    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, const Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getCachedTrivia()).called(1);
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });

  test('should return failure when the repository fails to get trivia',
      () async {
    // Arrange
    when(() => mockNumberTriviaRepository.getCachedTrivia())
        .thenAnswer((_) async => Left(ServerFailure()));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, Left(ServerFailure()));
    verify(() => mockNumberTriviaRepository.getCachedTrivia()).called(1);
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
