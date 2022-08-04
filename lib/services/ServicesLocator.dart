import 'package:get_it/get_it.dart';
import 'package:qq/services/ContestServcie.dart';
import 'package:qq/services/UserDataServcie.dart';

final getIt = GetIt.instance;


setupServiceLocator() {
  // Register UserDataService
  getIt.registerLazySingleton<UserDataService>(() => UserDataService());
  // Register ContestService
  getIt.registerLazySingleton<ContestService>(() => ContestService());
}