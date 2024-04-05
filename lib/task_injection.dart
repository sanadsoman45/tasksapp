import 'package:assignmenttask/core/platform/network_info.dart';
import 'package:assignmenttask/core/routes/route_config.dart';
import 'package:assignmenttask/features/PendingTasks/presentation/bloc/tasks_bloc.dart';
import 'package:assignmenttask/features/quotes/data/datasources/quote_remote_Datasource.dart';
import 'package:assignmenttask/features/quotes/data/repositories/quotes_Repository_impl.dart';
import 'package:assignmenttask/features/quotes/domain/repositories/quotes_repository.dart';
import 'package:assignmenttask/features/quotes/presentation/bloc/quotes_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //instance of internet connection checker so taht we can check for connectivity.
  serviceLocator.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());

  serviceLocator.registerLazySingleton<TaskBloc>(() => TaskBloc());

  serviceLocator.registerLazySingleton<NetworkInfo>(() => Networkinfoimpl(
      internetConnectionChecker: serviceLocator<InternetConnectionChecker>()));

  // go router delegate instance
  serviceLocator.registerLazySingleton<GoRouterDelegate>(
      () => AppRouteConfig().router.routerDelegate);

  //go routeinformationparser
  serviceLocator.registerLazySingleton<GoRouteInformationParser>(
      () => AppRouteConfig().router.routeInformationParser);
  serviceLocator.registerLazySingleton<GoRouteInformationProvider>(
      () => AppRouteConfig().router.routeInformationProvider);

  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerFactory<QuoteRemoteDataSource>(
      () => QuoteRemoteDataSourceImpl(dio: serviceLocator<Dio>()));

  serviceLocator.registerFactory<QuotesRepository>(() => QuotesRepositoryImpl(
      remoteDataSource:
          serviceLocator<QuoteRemoteDataSource>() as QuoteRemoteDataSourceImpl,
      networkInfo: serviceLocator<NetworkInfo>() as Networkinfoimpl));

  serviceLocator.registerLazySingleton<QuotesBloc>(() => QuotesBloc(
      quotesRepository:
          serviceLocator<QuotesRepository>() as QuotesRepositoryImpl));
}
