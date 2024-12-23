import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia/core/error/exceptions.dart';
import 'package:numbers_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../core/fixtures/fixture_reader.dart';
import '../../../mocks/number_trivia_mocks.dart';


void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      'should return NumberTrivia from SharedPreferences when there is one in cache',
      () async {
        //Arrange
        when(() => mockSharedPreferences.getString(any()))
            .thenReturn(fixture('trivia_cached.json'));
        //Act
        final result = await dataSource.getlastNumberTrivia();
        //Assert
        verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a CacheException when there not a cache value',
      () async {
        //Arrange
        when(() => mockSharedPreferences.getString(any())).thenReturn(null);
        //Act
        final call = dataSource.getlastNumberTrivia;
        //Assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumbertrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(trivia: 'test trivia', number: 1);
    test(
      'should call SharedPreferences to cache the data',
      () async {
        //Arrange
        when(() => mockSharedPreferences.setString(any(), any()))
            .thenAnswer((_) async => true);
        //Act
        dataSource.cacheNumberTrivia(tNumberTriviaModel);
        //Assert
        final expectedJsonString = json.encode(tNumberTriviaModel);
        verify(() => mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA, expectedJsonString));
      },
    );
  });
}
