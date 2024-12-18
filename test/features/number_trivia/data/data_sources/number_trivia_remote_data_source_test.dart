import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia/core/error/exceptions.dart';
import 'package:numbers_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://numbersapi.com/13'));
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setMockHttpClientSucess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setMockHttpClientFailure404() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 404));
  }

  group('getConcreteNumbertrivia', () {
    const tNumber = 1;
    final tNumbertriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number being the 
  endpoint with application/json header''',
      () async {
        // Arrange
        setMockHttpClientSucess200();
        // Act
        await dataSource.getConcreteNumberTrivia(tNumber);

        // Assert
        final url = Uri.parse('http://numbersapi.com/$tNumber');
        verify(() => mockHttpClient.get(url, headers: {
              'Content-Type': 'application/json',
            }));
      },
    );

    test(
      'should return NumberTrivia when response code is 200(success)',
      () async {
        //Arrange
        setMockHttpClientSucess200();
        //Act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        //Assert
        expect(result, equals(tNumbertriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other ',
      () async {
        //Arrange
        setMockHttpClientFailure404();
        //Act
        final call = dataSource.getConcreteNumberTrivia;
        //Assert
        expect(
            () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumbertrivia', () {
    final tNumbertriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number being the 
  endpoint with application/json header''',
      () async {
        // Arrange
        setMockHttpClientSucess200();
        // Act
        await dataSource.getRandomNumberTrivia();

        // Assert
        final url = Uri.parse('http://numbersapi.com/random');
        verify(() => mockHttpClient.get(url, headers: {
              'Content-Type': 'application/json',
            })).called(1);
      },
    );

    test(
      'should return NumberTrivia when response code is 200(success)',
      () async {
        //Arrange
        setMockHttpClientSucess200();
        //Act
        final result = await dataSource.getRandomNumberTrivia();
        //Assert
        expect(result, equals(tNumbertriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other ',
      () async {
        //Arrange
        setMockHttpClientFailure404();
        //Act
        final call = dataSource.getRandomNumberTrivia;
        //Assert
        expect(
            () => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
