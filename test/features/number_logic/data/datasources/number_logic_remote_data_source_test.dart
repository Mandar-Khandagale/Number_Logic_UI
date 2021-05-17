import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:number_logic/core/errors/exception.dart';
import 'package:number_logic/features/number_logic/data/datasources/number_logic_remote_data_source.dart';
import 'package:number_logic/features/number_logic/data/models/number_logic_model.dart';

import '../../../../fixtures/fixtures_reading.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberLogicRemoteDataSourceImpl dataSourceImpl;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl = NumberLogicRemoteDataSourceImpl(client: mockHttpClient);
  });

  group(
    'getUserNumberLogic',
    () {
      final tNumber = 1;
      final tNumberLogicModel = NumberLogicModel.fromJson(json.decode(fixture('logic.json')));

      test(
          "should preform a GET request on a URL with number being the endpoint and with application/json header",
          () {
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(fixture('logic.json'), 200),
        );

        dataSourceImpl.getUsersNumbers(tNumber);

        verify(mockHttpClient.get(
          'http://numbersapi.com/$tNumber',
          headers: {'Content-Type': 'application/json'},
        ));
      });

      test(
          'should return NumberTrivia when the response code is 200 (success)',
              () async{
            when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
                  (_) async => http.Response(fixture('logic.json'), 200),
            );

            final result = await dataSourceImpl.getUsersNumbers(tNumber);

           expect(result, equals(tNumberLogicModel));
          });

      test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
                (_) async => http.Response('Something went wrong', 404),
          );
          // act
          final call = dataSourceImpl.getUsersNumbers(tNumber);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        },
      );
    },
  );

  group(
    'getRandomNumberLogic',
        () {
      final tNumberLogicModel = NumberLogicModel.fromJson(json.decode(fixture('logic.json')));

      test(
          "should preform a GET request on a URL with number being the endpoint and with application/json header",
              () {
            when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
                  (_) async => http.Response(fixture('logic.json'), 200),
            );

            dataSourceImpl.getRandomNumbers();

            verify(mockHttpClient.get(
              'http://numbersapi.com/random',
              headers: {'Content-Type': 'application/json'},
            ));
          });

      test(
          'should return NumberTrivia when the response code is 200 (success)',
              () async{
            when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
                  (_) async => http.Response(fixture('logic.json'), 200),
            );

            final result = await dataSourceImpl.getRandomNumbers();

            expect(result, equals(tNumberLogicModel));
          });

      test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
                (_) async => http.Response('Something went wrong', 404),
          );
          // act
          final call = dataSourceImpl.getRandomNumbers();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        },
      );
    },
  );


}
