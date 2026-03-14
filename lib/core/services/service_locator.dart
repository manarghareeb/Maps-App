import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:maps_app/core/api/api_consumer.dart';
import 'package:maps_app/core/api/dio_consumer.dart';
import 'package:maps_app/core/cache/cache_helper.dart';
import 'package:maps_app/features/map/data/data_sources/map_remote_data_source.dart';
import 'package:maps_app/features/map/data/repositories/user_location_repository_impl.dart';
import 'package:maps_app/features/map/domain/repositories/user_location_repository.dart';
import 'package:maps_app/features/map/domain/usecases/fetch_route_osrm_usecase.dart';
import 'package:maps_app/features/map/domain/usecases/get_address_from_latlng_usecase.dart';
import 'package:maps_app/features/map/domain/usecases/get_current_location_usecase.dart';
import 'package:maps_app/features/map/domain/usecases/get_directions_usecase.dart';
import 'package:maps_app/features/map/presentation/cubit/directions_cubit/directions_cubit.dart';
import 'package:maps_app/features/map/presentation/cubit/map_cubit.dart';
import 'package:maps_app/features/search/data/data_sources/search_local_data_source.dart';
import 'package:maps_app/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:maps_app/features/search/data/repository/search_repository_impl.dart';
import 'package:maps_app/features/search/domain/repository/search_repository.dart';
import 'package:maps_app/features/search/domain/usecases/get_search_history_usecase.dart';
import 'package:maps_app/features/search/domain/usecases/remove_from_search_history_usecase.dart';
import 'package:maps_app/features/search/domain/usecases/save_search_history_usecase.dart';
import 'package:maps_app/features/search/domain/usecases/search_place_usecase.dart';
import 'package:maps_app/features/search/presentation/cubit/search_cubit.dart';

final sl = GetIt.instance;

void initServiceLocator() {
  /// External
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: sl()));
  sl.registerLazySingleton<CacheHelper>(() => CacheHelper());

  /// UseCases
  sl.registerLazySingleton(() => SearchPlacesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentLocationUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetSearchHistoryUsecase(repository: sl()));
  sl.registerLazySingleton(() => SaveSearchHistoryUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => RemoveFromSearchHistoryUsecase(repository: sl()),
  );
  sl.registerLazySingleton(() => GetDirectionsUseCase(repository: sl()));
  sl.registerLazySingleton(() => FetchRouteFromOSRMUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetAddressFromLatlngUsecase(repository: sl()));

  /// DataSources
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(apiConsumer: sl()),
  );
  sl.registerLazySingleton<SearchLocalDataSource>(
    () => SearchLocalDataSourceImpl(cacheHelper: sl()),
  );
  sl.registerLazySingleton<MapRemoteDataSource>(
    () => MapRemoteDataSourceImpl(apiConsumer: sl(), dio: sl()),
  );

  // Cubit
  sl.registerFactory(() => MapCubit(getCurrentLocationUseCase: sl(), getAddressFromLatLngUseCase: sl()));
  sl.registerFactory(
    () => SearchCubit(
      searchUseCase: sl(),
      getHistoryUseCase: sl(),
      saveHistoryUseCase: sl(),
      removeHistoryUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => DirectionsCubit(
      getDirectionsUseCase: sl(),
      fetchRouteFromOSRMUseCase: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<UserLocationRepository>(
    () => UserLocationRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
}
