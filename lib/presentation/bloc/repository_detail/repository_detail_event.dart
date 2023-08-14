abstract class RepositoryDetailEvent {}

class FetchRepositoryDetail extends RepositoryDetailEvent {
  final String owner;
  final String repoName;

  FetchRepositoryDetail(this.owner, this.repoName);
}
