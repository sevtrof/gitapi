import 'package:gitgub_api_app/data/models/repository_model.dart';
import 'package:gitgub_api_app/data/models/issue_pr_model.dart';
import 'package:gitgub_api_app/data/sources/remote_data_source.dart';
import 'package:gitgub_api_app/domain/entities/repository.dart';
import 'package:gitgub_api_app/domain/entities/issue_pr.dart';
import 'package:gitgub_api_app/domain/repositories/git_repository.dart';
import 'package:gitgub_api_app/utils/sort_util.dart';

class GithubRepositoryImpl implements GithubRepository {
  final RemoteDataSource remoteDataSource;

  GithubRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Repository>> searchRepositories(String keyword,
      {int page = 1, RepoSort? sort, SortOrder? order}) async {
    final List<RepositoryModel> repoModels =
        await remoteDataSource.searchRepositories(keyword, page: page);
    return repoModels.map((model) => model.toDomain()).toList();
  }

  @override
  Future<Repository> getRepositoryDetail(String owner, String repoName) async {
    final RepositoryModel repoModel =
        await remoteDataSource.getRepositoryDetail(owner, repoName);
    return repoModel.toDomain();
  }

  @override
  Future<List<IssueOrPR>> getIssuesOrPRs(String owner, String repoName) async {
    final List<IssueOrPRModel> issueModels =
        await remoteDataSource.getIssuesOrPRs(owner, repoName);
    return issueModels.map((model) => model.toDomain()).toList();
  }
}

extension on RepositoryModel {
  Repository toDomain() {
    return Repository(
      name: name ?? 'No name',
      owner: owner ?? 'No owner',
      description: description ?? 'No description',
      stars: stars ?? -1,
      forks: forks ?? -1,
    );
  }
}

extension on IssueOrPRModel {
  IssueOrPR toDomain() {
    return IssueOrPR(
      id: id,
      title: title,
      description: body,
      url: htmlUrl,
      state: state,
      isPullRequest: isPullRequest,
    );
  }
}
