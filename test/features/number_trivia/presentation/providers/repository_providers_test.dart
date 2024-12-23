import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/core/network/network_info.dart';
import 'package:numbers_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_cached_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/providers/repository_providers.dart';

import '../../../mocks/number_trivia_mocks.dart';

void main() {
  late ProviderContainer container;

  // SharedPreferences Test
  group('sharedPreferencesProvider', () {
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      container = ProviderContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
      ]);
    });

    tearDown(() {
      container.dispose();
    });

    test('should provide an instance of SharedPreferences', () {
      final sharedPreferences = container.read(sharedPreferencesProvider);
      expect(sharedPreferences, mockSharedPreferences);
    });
  });

  // Local Data Source Test
  group('triviaLocalDataSourceProvider', () {
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      container = ProviderContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
      ]);
    });

    tearDown(() {
      container.dispose();
    });

    test('should provide an instance of NumberTriviaLocalDataSourceImpl', () {
      final localDataSource = container.read(triviaLocalDataSourceProvider);
      expect(localDataSource, isA<NumberTriviaLocalDataSourceImpl>());
    });
  });

  // NetworkInfo Test
  group('networkInfoProvider', () {
    late MockInternetConnectionChecker mockConnectionChecker;

    setUp(() {
      mockConnectionChecker = MockInternetConnectionChecker();
      container = ProviderContainer(overrides: [
        networkInfoProvider.overrideWithValue(
          NetworkInfoImpl(connectionChecker: mockConnectionChecker),
        ),
      ]);
    });

    tearDown(() {
      container.dispose();
    });

    test('should provide an instance of NetworkInfoImpl', () {
      final networkInfo = container.read(networkInfoProvider);
      expect(networkInfo, isA<NetworkInfoImpl>());
    });
  });

  // Remote Data Source Test
  group('triviaRemoteDataSourceProvider', () {
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      container = ProviderContainer(overrides: [
        triviaRemoteDataSourceProvider.overrideWithValue(
          NumberTriviaRemoteDataSourceImpl(client: mockHttpClient),
        ),
      ]);
    });

    tearDown(() {
      container.dispose();
    });

    test('should provide an instance of NumberTriviaRemoteDataSourceImpl', () {
      final remoteDataSource = container.read(triviaRemoteDataSourceProvider);
      expect(remoteDataSource, isA<NumberTriviaRemoteDataSourceImpl>());
    });
  });

  // Repository Provider Test
  group('triviaRepositoryProvider', () {
    late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
    late MockNumberTriviaLocalDataSource mockLocalDataSource;
    late MockNetworkInfo mockNetworkInfo;

    setUp(() {
      mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
      mockLocalDataSource = MockNumberTriviaLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();

      container = ProviderContainer(overrides: [
        triviaRemoteDataSourceProvider.overrideWithValue(mockRemoteDataSource),
        triviaLocalDataSourceProvider.overrideWithValue(mockLocalDataSource),
        networkInfoProvider.overrideWithValue(mockNetworkInfo),
      ]);
    });

    tearDown(() {
      container.dispose();
    });

    test('should provide an instance of NumberTriviaRepositoryImpl', () {
      final repository = container.read(triviaRepositoryProvider);
      expect(repository, isA<NumberTriviaRepositoryImpl>());
    });
  });

  // UseCase Providers Test
  group('UseCase Providers', () {
    late MockNumberTriviaRepository mockRepository;

    setUp(() {
      mockRepository = MockNumberTriviaRepository();

      container = ProviderContainer(overrides: [
        triviaRepositoryProvider.overrideWithValue(mockRepository),
      ]);
    });

    tearDown(() {
      container.dispose();
    });

    test('should provide an instance of GetConcreteNumberTrivia', () {
      final getConcrete = container.read(concreteTriviaprovider);
      expect(getConcrete, isA<GetConcreteNumberTrivia>());
    });

    test('should provide an instance of GetRandomNumberTrivia', () {
      final getRandom = container.read(randomTriviaprovider);
      expect(getRandom, isA<GetRandomNumberTrivia>());
    });

    test('should provide an instance of GetCachedNumberTrivia', () {
      final getCached = container.read(cachedTriviaProvider);
      expect(getCached, isA<GetCachedNumberTrivia>());
    });
  });
}
