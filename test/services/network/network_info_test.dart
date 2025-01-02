import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia/services/network/network_info.dart';

class MockInternetConnection extends Mock implements InternetConnection {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnection mockInternetConnection;

  setUp(() {
    mockInternetConnection = MockInternetConnection();
    networkInfoImpl =
        NetworkInfoImpl(connectionChecker: mockInternetConnection);
  });

  group('isConnected', () {
    test(
      'should forward the call to InternetConnection().hasInternetAccess',
      () async {
        //Arrange
        final tHasConnectionFuture = Future.value(true);

        when(() => mockInternetConnection.hasInternetAccess)
            .thenAnswer((_) => tHasConnectionFuture);
        //Act
        final result = networkInfoImpl.isConnected;
        //Assert
        verify(() => mockInternetConnection.hasInternetAccess);
        expect(result, equals(tHasConnectionFuture));
      },
    );
  });
}
