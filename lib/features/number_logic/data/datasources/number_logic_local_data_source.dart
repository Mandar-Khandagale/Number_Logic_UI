import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:number_logic/core/errors/exception.dart';
import 'package:number_logic/features/number_logic/data/models/number_logic_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberLogicLocalDataSource{

  Future<NumberLogicModel> getLastNumberLogic();
  Future<void> cacheNumberLogic(NumberLogicModel logicToCache);
}

const CACHED_NUMBER_LOGIC = 'CACHED_NUMBER_LOGIC';

class NumberLogicLocalDataSourceImpl implements NumberLogicLocalDataSource{
  final SharedPreferences sharedPreferences;

  NumberLogicLocalDataSourceImpl({ @required this.sharedPreferences});


  @override
  Future<NumberLogicModel> getLastNumberLogic() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_LOGIC);

    if(jsonString != null){
      return Future.value(NumberLogicModel.fromJson(json.decode(jsonString)));
    }else{
      throw CacheException();
    }

  }

  @override
  Future<void> cacheNumberLogic(NumberLogicModel logicToCache) {
    return sharedPreferences.setString(CACHED_NUMBER_LOGIC, json.encode(logicToCache.toJson()));
  }


}
