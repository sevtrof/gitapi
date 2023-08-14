class IssueOrPRModel {
  final int id;
  final String title;
  final String body;
  final String htmlUrl;
  final String state;
  final bool isPullRequest;

  IssueOrPRModel({
    required this.id,
    required this.title,
    required this.body,
    required this.htmlUrl,
    required this.state,
    required this.isPullRequest,
  });

  factory IssueOrPRModel.fromJson(Map<String, dynamic> json) {
    return IssueOrPRModel(
      id: json['id'],
      title: json['title'],
      body: json['body'] ?? '',
      htmlUrl: json['html_url'],
      state: json['state'],
      isPullRequest: json.containsKey('pull_request'),
    );
  }
}
