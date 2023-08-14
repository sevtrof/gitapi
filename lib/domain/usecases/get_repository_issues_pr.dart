import 'package:gitgub_api_app/domain/entities/issue_pr.dart';
import 'package:gitgub_api_app/domain/repositories/git_repository.dart';

class GetIssuesOrPRsUsecase {
  final GithubRepository repository;

  GetIssuesOrPRsUsecase(this.repository);

  Future<List<IssueOrPR>> call(String owner, String repoName) async {
    return await repository.getIssuesOrPRs(owner, repoName);
  }
}
