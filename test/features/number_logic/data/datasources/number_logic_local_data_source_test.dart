import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_logic/core/errors/exception.dart';
import 'package:number_logic/features/number_logic/data/datasources/number_logic_local_data_source.dart';
import 'package:number_logic/features/number_logic/data/models/number_logic_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixtures_reading.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {

  NumberLogicLocalDataSourceImpl numberLogicLocalDataSourceImpl;
  MockSharedPreferences mockSharedPreferences;

  setUp((){

    mockSharedPreferences = MockSharedPreferences();
    numberLogicLocalDataSourceImpl = NumberLogicLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });
  
  group('getLastNumberLogic', () {
    final tNumberLogicModel = NumberLogicModel.fromJson(json.decode(fixture('logic_cached.json')));
    test(
        "should return NumberTrivia from SharedPreferences when there is one in the cache",
        () async{

          when(mockSharedPreferences.getString(any))
              .thenReturn(fixture('logic_cached.json'));

          final result = await numberLogicLocalDataSourceImpl.getLastNumberLogic();
          
          verify(mockSharedPreferences.getString(CACHED_NUMBER_LOGIC));
          expect(result, equals(tNumberLogicModel));
        });

    test(
        "should throw a CacheException when there is not a cached value ",
            () async{

          when(mockSharedPreferences.getString(any))
              .thenReturn(null);

          final call =  numberLogicLocalDataSourceImpl.getLastNumberLogic;

          expect(() => call(), throwsA(isA<CacheException>()));
        });
      });

  group('cachedNumberLogic', () {
    final tNumberLogicModel = NumberLogicModel(text: 'test logic', number: 1);

    test(
        'should call SharedPreferences to cache the data',
        () {
          numberLogicLocalDataSourceImpl.cacheNumberLogic(tNumberLogicModel);

          final expectedJsonString = json.encode(tNumberLogicModel.toJson());
          verify(mockSharedPreferences.setString(CACHED_NUMBER_LOGIC, expectedJsonString));
        }
    );

  });

}