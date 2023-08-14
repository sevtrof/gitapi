class IssueOrPR {
  final int id;
  final String title;
  final String description;
  final String url;
  final String state;
  final bool isPullRequest;

  IssueOrPR({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.state,
    required this.isPullRequest,
  });
}
