import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/core/error/exceptions.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia/services/network/network_info.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  Future<Either<Failures, NumberTrivia>> _getTrivia(
    Future<NumberTriviaModel> Function() getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(e.message));
      }
    } else {
      try {
        final localTrivia = await localDataSource.getlastNumberTrivia();
        return Right(localTrivia);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  @override
  Future<Either<Failures, NumberTrivia>> getCachedTrivia() async {
    try {
      final cachedTrivia = await localDataSource.getlastNumberTrivia();
      return Right(cachedTrivia);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
