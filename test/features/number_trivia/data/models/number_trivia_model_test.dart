import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, trivia: 'Test Test');

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // Assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group(
    'fromJson',
    () {
      test(
        'should return a valid model when the JSON number is an interger',
        () async {
          //Arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('trivia.json'));
          //Act
          final result = NumberTriviaModel.fromJson(jsonMap);
          //Assert
          expect(result, tNumberTriviaModel);
        },
      );

      test(
        'should return a valid model when the JSON number is a double',
        () async {
          //Arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('trivia_double.json'));
          //Act
          final result = NumberTriviaModel.fromJson(jsonMap);
          //Assert
          expect(result, tNumberTriviaModel);
        },
      );
    },
  );

  group("toJson", () {
    test(
      'should return a JSON map containing proper data',
      () async {
        //Arrange
        final expectedMap = {
          "text": "Test Test",
          "number": 1,
        };
        //Act
        final result = tNumberTriviaModel.toJson();
        //Assert
        expect(result, expectedMap);
      },
    );
  });
}
