import 'package:dio/dio.dart';
import 'package:eduquest_ai/core/networking/api_service.dart';
import 'package:eduquest_ai/core/networking/dio_factory.dart';
import 'package:eduquest_ai/features/auth/data/repos/auth_repo.dart';
import 'package:eduquest_ai/features/auth/logic/auth_cubit.dart';
import 'package:eduquest_ai/features/course/data/repos/course_repo.dart';
import 'package:eduquest_ai/features/course/data/repos/courses_api_service.dart';
import 'package:eduquest_ai/features/course/logic/course_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio & ApiService
  Dio dio = await DioFactory.getDio();
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  // Auth
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(getIt()));
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));

  // Courses
  getIt.registerLazySingleton<CoursesApiService>(() => CoursesApiService(dio));
  getIt.registerLazySingleton<CourseRepo>(() => CourseRepo(getIt()));
  getIt.registerFactory<CourseCubit>(() => CourseCubit(getIt()));
}
