import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/core/usecases/usecase.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetCachedNumberTrivia implements Usecase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetCachedNumberTrivia({required this.repository});

  @override
  Future<Either<Failures, NumberTrivia>> call(NoParams params) async {
    return repository.getCachedTrivia();
  }
}
