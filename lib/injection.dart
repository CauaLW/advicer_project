import 'package:advicer_project/application/pages/advice/cubit/advice_cubit.dart';
import 'package:advicer_project/data/datasources/advice_remote_datasource.dart';
import 'package:advicer_project/data/repositories/advice_repo_impl.dart';
import 'package:advicer_project/domain/features/advice_feature.dart';
import 'package:advicer_project/domain/repositories/advice_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.I;

Future<void> init() async {
  // Application Layer

  // Singleton = always return the existent instance
  // serviceLocator.registerSingleton(() => AdviceCubit(adviceFeature: serviceLocator()));

  // Factory = always return a new instance
  serviceLocator.registerFactory(() => AdviceCubit(adviceFeature: serviceLocator()));

  // Domain Layer

  serviceLocator.registerFactory(() => AdviceFeature(adviceRepo: serviceLocator()));

  // Data Layer
  serviceLocator.registerFactory<AdviceRepo>(() => AdviceRepoImpl(adviceRemoteDatasource: serviceLocator()));
  serviceLocator.registerFactory<AdviceRemoteDatasource>(() => AdviceRemoteDatasourceImpl(client: serviceLocator()));

  // Externs
  serviceLocator.registerFactory(() => http.Client());
}
