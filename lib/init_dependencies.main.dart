part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  _initProfile();
  _initComments();
  _initNotifications();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
 
  serviceLocator.registerLazySingleton(() => supabase.client);


  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
  serviceLocator.registerLazySingleton(
    () => ThemeCubit(),
  );
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogout(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        userLogout: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  // Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )

    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => SearchBlogs(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ToggleLike(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ToggleBookmark(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetBookmarkedBlogs(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
        deleteBlog: serviceLocator(),
        updateBlog: serviceLocator(),
        searchBlogs: serviceLocator(),
        toggleLike: serviceLocator(),
        toggleBookmark: serviceLocator(),
        getBookmarkedBlogs: serviceLocator(),
      ),
    );
}

void _initProfile() {
  // Datasource
  serviceLocator
    ..registerFactory<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<ProfileRepository>(
      () => ProfileRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => GetUserBlogs(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateProfile(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => ProfileBloc(
        getUserBlogs: serviceLocator(),
        updateProfile: serviceLocator(),
      ),
    );
}

void _initComments() {
  // Datasource
  serviceLocator
    ..registerFactory<CommentRemoteDataSource>(
      () => CommentRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<CommentRepository>(
      () => CommentRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => GetComments(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => AddComment(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateComment(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteComment(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerFactory(
      () => CommentBloc(
        getComments: serviceLocator(),
        addComment: serviceLocator(),
        updateComment: serviceLocator(),
        deleteComment: serviceLocator(),
      ),
    );
}

void _initNotifications() {
  // Datasource
  serviceLocator
    ..registerFactory<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<NotificationRepository>(
      () => NotificationRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => GetNotifications(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => MarkNotificationRead(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => MarkAllNotificationsRead(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetUnreadCount(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => NotificationBloc(
        getNotifications: serviceLocator(),
        markNotificationRead: serviceLocator(),
        markAllNotificationsRead: serviceLocator(),
        getUnreadCount: serviceLocator(),
      ),
    );
}
