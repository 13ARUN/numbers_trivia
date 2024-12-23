import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia/core/error/exceptions.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbers_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../core/mocks/core_mocks.dart';
import '../../../../core/mocks/number_trivia_mocks.dart';

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(
        const NumberTriviaModel(trivia: 'dummy trivia', number: 0));
  });

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void setUpOnline() {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockLocalDataSource.cacheNumberTrivia(any()))
          .thenAnswer((_) async => Future.value());
    });
  }

  void setUpOffline() {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(trivia: 'test trivia', number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check the connection status of device', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource.cacheNumberTrivia(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      await repository.getConcreteNumberTrivia(tNumber);

      // Assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    // Device is online
    group('device is online', () {
      setUpOnline();

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // Arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);

        // Act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        // Arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);

        // Act
        await repository.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // Arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenThrow(ServerException());

        // Act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    // Device is offline
    group('device is offline', () {
      setUpOffline();

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // Arrange
        when(() => mockLocalDataSource.getlastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // Act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getlastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return Cachefailure when there is no cached data present',
          () async {
        // Arrange
        when(() => mockLocalDataSource.getlastNumberTrivia())
            .thenThrow(CacheException());
        // Act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getlastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(trivia: 'test trivia', number: 123);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check the connection status of device', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource.cacheNumberTrivia(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      await repository.getRandomNumberTrivia();

      // Assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    // Device is online
    group('device is online', () {
      setUpOnline();

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // Arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        // Act
        final result = await repository.getRandomNumberTrivia();
        // Assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        // Arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        // Act
        await repository.getRandomNumberTrivia();
        // Assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // Arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        // Act
        final result = await repository.getRandomNumberTrivia();
        // Assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    // Device is offline
    group('device is offline', () {
      setUpOffline();

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // Arrange
        when(() => mockLocalDataSource.getlastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // Act
        final result = await repository.getRandomNumberTrivia();
        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getlastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return Cachefailure when there is no cached data present',
          () async {
        // Arrange
        when(() => mockLocalDataSource.getlastNumberTrivia())
            .thenThrow(CacheException());
        // Act
        final result = await repository.getRandomNumberTrivia();
        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getlastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getCachedTrivia', () {
    const tCachedNumberTriviaModel =
        NumberTriviaModel(trivia: 'test trivia', number: 123);
    const NumberTrivia tNumberTrivia = tCachedNumberTriviaModel;
    test(
        'should return last locally cached data when the cached data is present',
        () async {
      // Arrange
      when(() => mockLocalDataSource.getlastNumberTrivia())
          .thenAnswer((_) async => tCachedNumberTriviaModel);
      // Act
      final result = await repository.getCachedTrivia();
      // Assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(() => mockLocalDataSource.getlastNumberTrivia());
      expect(result, equals(const Right(tNumberTrivia)));
    });

    test('should return Cachefailure when there is no cached data present',
          () async {
        // Arrange
        when(() => mockLocalDataSource.getlastNumberTrivia())
            .thenThrow(CacheException());
        // Act
        final result = await repository.getCachedTrivia();
        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getlastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
  });
}
