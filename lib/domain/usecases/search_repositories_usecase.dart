import 'package:gitgub_api_app/domain/entities/repository.dart';
import 'package:gitgub_api_app/domain/repositories/git_repository.dart';
import 'package:gitgub_api_app/utils/sort_util.dart';

class SearchRepositories {
  final GithubRepository repository;

  SearchRepositories(this.repository);

  Future<List<Repository>> call(String keyword, {int page = 1, RepoSort? sort, SortOrder? order}) {
    return repository.searchRepositories(keyword, page: page, sort: sort, order: order);
  }
}
