import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_logic/features/number_logic/data/models/number_logic_model.dart';
import 'package:number_logic/features/number_logic/domain/entities/number_logic.dart';

import '../../../../fixtures/fixtures_reading.dart';

void main() {
  final tNumberLogicModel = NumberLogicModel(text: 'test text', number: 1);

  test('should be a subclass of NumberLogic entity', () async {
    expect(tNumberLogicModel, isA<NumberLogic>());
  });

  group('fromJson', () {
    test(
      'should return a valid model when the json number is an integer',
      () async {
        final Map<String, dynamic> jsonMap = json.decode(fixture('logic.json'));

        final result = NumberLogicModel.fromJson(jsonMap);
        expect(result, tNumberLogicModel);
      },
    );
    test(
      'should return a valid model when the json number is regarded as double',
      () async {
        final Map<String, dynamic> jsonMap = json.decode(fixture('logic_double.json'));

        final result = NumberLogicModel.fromJson(jsonMap);
        expect(result, tNumberLogicModel);
      },
    );
  });

  group('toJson', () {
    test(
        'should return a JSON map containing a proper data',
        () async{
          final result  = tNumberLogicModel.toJson();
          final expectedMap = {
            "text" : "test text",
            "number" : 1,
          };
          expect(result, expectedMap);
        }
        );
  });

}
