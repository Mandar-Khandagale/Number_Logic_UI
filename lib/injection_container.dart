import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:number_logic/core/network/network_info.dart';
import 'package:number_logic/features/number_logic/data/datasources/number_logic_local_data_source.dart';
import 'package:number_logic/features/number_logic/data/datasources/number_logic_remote_data_source.dart';
import 'package:number_logic/features/number_logic/data/repositories/number_logic_repo_impl.dart';
import 'package:number_logic/features/number_logic/domain/repositories/number_logic_repo.dart';
import 'package:number_logic/features/number_logic/domain/usecase/get_random_number.dart';
import 'package:number_logic/features/number_logic/domain/usecase/get_users_number.dart';
import 'package:number_logic/features/number_logic/presentation/bloc/number_logic_bloc.dart';
import 'package:number_logic/utils/input_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async{
  /// Features - Number Logic
  //Bloc
  sl.registerFactory(
    () => NumberLogicBloc(
      users: sl(),
      random: sl(),
      inputConverter: sl(),
    ),
  );

  // use cases
  sl.registerLazySingleton(() => GetUsersNumber(sl()));
  sl.registerLazySingleton(() => GetRandomNumber(sl()));

  // Repository
  sl.registerLazySingleton<NumberLogicRepo>(
    () => NumberLogicRepoImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<NumberLogicRemoteDataSource>(
    () => NumberLogicRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NumberLogicLocalDataSource>(
    () => NumberLogicLocalDataSourceImpl(sharedPreferences: sl()),
  );

  /// Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  /// External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
