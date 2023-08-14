import 'package:gitgub_api_app/domain/entities/repository.dart';
import 'package:gitgub_api_app/domain/repositories/git_repository.dart';

class GetRepositoryDetail {
  final GithubRepository repository;

  GetRepositoryDetail(this.repository);

  Future<Repository> call(String owner, String repoName) {
    return repository.getRepositoryDetail(owner, repoName);
  }
}
