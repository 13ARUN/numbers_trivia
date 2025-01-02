// Mocks for the core
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia/services/network/network_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockHttpClient extends Mock implements http.Client {}

class MockInternetConnectionChecker extends Mock
    implements InternetConnection {}