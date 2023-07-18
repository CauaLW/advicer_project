import 'package:advicer_project/data/datasources/advice_remote_datasource.dart';
import 'package:advicer_project/data/exceptions/exceptions.dart';
import 'package:advicer_project/data/models/advice_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart';

import 'advice_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Client>()])
void main() {
  group('AdviceRemoteDataSource', () {
    const String baseUrl = 'https://api.flutter-community.com/api/v1';
    final mockClient = MockClient();

    final adviceRemoteDatasourceUnderTest = AdviceRemoteDatasourceImpl(client: mockClient);
    group('should return AdviceModel', () {
      test('when Client response was 200 and has valid data', () async {
        const String responseBody = '{"advice": "Test Advice", "advice_id": 1}';

        when(
          mockClient.get(
            Uri.parse('$baseUrl/advice'),
            headers: {
              'content-type': 'application/json',
            },
          ),
        ).thenAnswer((realInvocation) => Future.value(Response(responseBody, 200)));

        final result = await adviceRemoteDatasourceUnderTest.getRandomAdviceFromApi();

        expect(result, AdviceModel(advice: 'Test Advice', id: 1));
      });
    });
    group('should throw', () {
      test('a ServerException when Client response was different from 200', () {
        when(
          mockClient.get(
            Uri.parse('$baseUrl/advice'),
            headers: {
              'content-type': 'application/json',
            },
          ),
        ).thenAnswer((realInvocation) => Future.value(Response('', 500)));

        expect(() => adviceRemoteDatasourceUnderTest.getRandomAdviceFromApi(), throwsA(isA<ServerException>()));
      });

      test('a TypeError when Client response was 200 and has no valid data', () {
        const String responseBody = '{"advice": "Advice withouth id"}';
        when(
          mockClient.get(
            Uri.parse('$baseUrl/advice'),
            headers: {
              'content-type': 'application/json',
            },
          ),
        ).thenAnswer((realInvocation) => Future.value(Response(responseBody, 200)));

        expect(() => adviceRemoteDatasourceUnderTest.getRandomAdviceFromApi(), throwsA(isA<TypeError>()));
      });
    });
  });
}
