import 'package:gitgub_api_app/domain/usecases/get_repository_details.dart';
import 'package:gitgub_api_app/domain/usecases/get_repository_issues_pr.dart';
import 'package:http/http.dart' as http;
import 'package:gitgub_api_app/data/repositories/git_repository_impl.dart';
import 'package:gitgub_api_app/data/sources/remote_data_source.dart';
import 'package:gitgub_api_app/domain/repositories/git_repository.dart';
import 'package:gitgub_api_app/domain/usecases/search_repositories_usecase.dart';
import 'package:get_it/get_it.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton<http.Client>(() => http.Client());
  GetIt.I.registerLazySingleton<RemoteDataSource>(() => RemoteDataSource(
        client: GetIt.I.get<http.Client>(),
      ));
  GetIt.I.registerLazySingleton<GithubRepository>(() => GithubRepositoryImpl(
        GetIt.I.get<RemoteDataSource>(),
      ));
  GetIt.I.registerLazySingleton<SearchRepositories>(() => SearchRepositories(
        GetIt.I.get(),
      ));
  GetIt.I.registerLazySingleton<GetRepositoryDetail>(() => GetRepositoryDetail(
        GetIt.I.get(),
      ));
  GetIt.I.registerLazySingleton<GetIssuesOrPRsUsecase>(() => GetIssuesOrPRsUsecase(
    GetIt.I.get(),
  ));
}
