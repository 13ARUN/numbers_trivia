import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/core/usecases/usecase.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements Usecase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia({required this.repository});
  @override
  Future<Either<Failures, NumberTrivia>> call(params) async {
    return await repository.getRandomNumberTrivia();
  }
}
