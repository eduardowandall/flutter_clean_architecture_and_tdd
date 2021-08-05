import 'package:flutter_clean_architecture_and_tdd/core/network/network_info.dart';
import 'package:flutter_clean_architecture_and_tdd/core/presentation/util/input_converter.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';

// service locator
final sl = GetIt.instance;

Future<void> init() async {
  // features - number trivia
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl()));
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            remoteDataSource: sl(),
            localDataSource: sl(),
            networkInfo: sl(),
          ));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sl()));

  // core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
