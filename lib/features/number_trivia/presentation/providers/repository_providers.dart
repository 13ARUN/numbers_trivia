import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:numbers_trivia/services/network/network_info.dart';
import 'package:numbers_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_cached_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final networkInfoProvider = Provider<NetworkInfo>(
  (ref) {
    final connectionChecker = InternetConnection();
    return NetworkInfoImpl(connectionChecker: connectionChecker);
  },
);

final triviaLocalDataSourceProvider =
    Provider<NumberTriviaLocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return NumberTriviaLocalDataSourceImpl(sharedPreferences: sharedPreferences);
});

final triviaRemoteDataSourceProvider =
    Provider<NumberTriviaRemoteDataSource>((ref) {
  final client = http.Client();
  return NumberTriviaRemoteDataSourceImpl(client: client);
});

final triviaRepositoryProvider = Provider<NumberTriviaRepository>((ref) {
  final remoteDataSource = ref.watch(triviaRemoteDataSourceProvider);
  final localDataSource = ref.watch(triviaLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return NumberTriviaRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
});

final concreteTriviaProvider = Provider<GetConcreteNumberTrivia>(
  (ref) {
    final repository = ref.read(triviaRepositoryProvider);
    return GetConcreteNumberTrivia(repository: repository);
  },
);

final randomTriviaProvider = Provider<GetRandomNumberTrivia>(
  (ref) {
    final repository = ref.read(triviaRepositoryProvider);
    return GetRandomNumberTrivia(repository: repository);
  },
);

final cachedTriviaProvider = Provider<GetCachedNumberTrivia>((ref) {
  final repository = ref.read(triviaRepositoryProvider);
  return GetCachedNumberTrivia(repository: repository);
});
