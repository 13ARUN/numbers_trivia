import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:numbers_trivia/core/network/network_info.dart';
import 'package:numbers_trivia/core/usecases/usecase.dart';
import 'package:numbers_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_cached_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // Replace with async initialization in main
});

final triviaLocalDataSourceProvider =
    Provider<NumberTriviaLocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return NumberTriviaLocalDataSourceImpl(sharedPreferences: sharedPreferences);
});

final networkInfoProvider = Provider<NetworkInfo>(
  (ref) {
    final connectionChecker = InternetConnection();
    return NetworkInfoImpl(connectionChecker: connectionChecker);
  },
);

final triviaRemoteDataSourceProvider =
    Provider<NumberTriviaRemoteDataSource>((ref) {
  final client = http.Client(); // Create an HTTP client instance
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

final concreteTriviaprovider = Provider<GetConcreteNumberTrivia>(
  (ref) {
    final repository = ref.read(triviaRepositoryProvider);
    return GetConcreteNumberTrivia(repository: repository);
  },
);

final randomTriviaprovider = Provider<GetRandomNumberTrivia>(
  (ref) {
    final repository = ref.read(triviaRepositoryProvider);
    return GetRandomNumberTrivia(repository: repository);
  },
);

final cachedTriviaProvider = Provider<GetCachedNumberTrivia>((ref) {
  final repository = ref.read(triviaRepositoryProvider);
  return GetCachedNumberTrivia(repository: repository);
});

final triviaProvider =
    StateNotifierProvider<TriviaNotifier, AsyncValue<NumberTrivia>>((ref) {
  final getConcreteTrivia = ref.read(concreteTriviaprovider);
  final getRandomTrivia = ref.read(randomTriviaprovider);
  final getCachedTrivia = ref.read(cachedTriviaProvider);

  return TriviaNotifier(getConcreteTrivia, getRandomTrivia, getCachedTrivia);
});

class TriviaNotifier extends StateNotifier<AsyncValue<NumberTrivia>> {
  final GetConcreteNumberTrivia _getConcrete;
  final GetRandomNumberTrivia _getRandom;
  final GetCachedNumberTrivia _getCached;

  TriviaNotifier(this._getConcrete, this._getRandom, this._getCached)
      : super(const AsyncValue.loading()) {
    // Fetch cached trivia on initialization
    _fetchCachedTrivia();
  }

  Future<void> _fetchCachedTrivia() async {
    try {
      final result = await _getCached(NoParams());
      result.fold(
        (failure) {
          state = const AsyncValue.data(NumberTrivia(
              trivia: 'Start Seaching', number: 0)); // No cached data
        },
        (trivia) {
          state = AsyncValue.data(trivia); // Display cached data
        },
      );
    } catch (e) {
      state = const AsyncValue.data(NumberTrivia(
          trivia: 'Start Seaching', number: 0)); // Handle unexpected errors
    }
  }

  Future<void> getConcrete(int num) async {
    state = const AsyncValue.loading();
    try {
      final result = await _getConcrete(Params(number: num));
      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (trivia) => AsyncValue.data(trivia),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> getRandom() async {
    state = const AsyncValue.loading();
    try {
      final result = await _getRandom(NoParams());
      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (trivia) => AsyncValue.data(trivia),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
