import 'package:get_it/get_it.dart';
import 'package:very_good_coffee_app/data/storage_repository.dart';

/// The global instance of [GetIt].
///
final getIt = GetIt.instance;

/// Registers all dependencies with [GetIt].
///
void registerGetIt() {
  getIt.registerLazySingleton(StorageRepository.new);
}
