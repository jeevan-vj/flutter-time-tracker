final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Repositories
  getIt.registerLazySingleton<TimeEntryRepository>(
    () => TimeEntryRepositoryImpl(getIt()),
  );

  // Blocs
  getIt.registerFactory(
    () => TimeEntryBloc(timerRepository: getIt()),
  );
} 