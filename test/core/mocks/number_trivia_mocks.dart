import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_cached_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

// Mocks for the data sources
class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

// Mocks for the repository
class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

// Mocks for the usecases
class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockGetCachedNumberTrivia extends Mock implements GetCachedNumberTrivia {}
