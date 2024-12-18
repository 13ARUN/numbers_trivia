import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // Use mocktail package
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

// Create a Mock class for NumberTriviaRepository using mocktail
class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);

    // Register the mocktail fallback for the NumberTriviaRepository method
    registerFallbackValue(const NumberTrivia(number: 1, trivia: 'test'));
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, trivia: 'test');

  test('should get trivia for the number from the repository', () async {
    // Arrange
    when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
        .thenAnswer((_) async => const Right(tNumberTrivia));
    // Act
    final result = await usecase(const Params(number: tNumber));

    // Assert
    expect(result, const Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
        .called(1);
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });

  test('should return failure when the repository fails to get trivia',
      () async {
    // Arrange
    when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
        .thenAnswer((_) async => Left(ServerFailure()));

    // Act
    final result = await usecase(const Params(number: tNumber));

    // Assert
    expect(result, Left(ServerFailure()));
    verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
        .called(1);
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
