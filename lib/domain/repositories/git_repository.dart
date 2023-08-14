import 'package:gitgub_api_app/domain/entities/issue_pr.dart';
import 'package:gitgub_api_app/domain/entities/repository.dart';
import 'package:gitgub_api_app/utils/sort_util.dart';

abstract class GithubRepository {
  Future<List<Repository>> searchRepositories(String keyword, {int page = 1, RepoSort? sort, SortOrder? order});

  Future<Repository> getRepositoryDetail(String owner, String repoName);

  Future<List<IssueOrPR>> getIssuesOrPRs(String owner, String repoName);
}
