class RepositoryModel {
  final String? name;
  final String? owner;
  final String? description;
  final int? stars;
  final int? forks;

  RepositoryModel({
    required this.name,
    required this.owner,
    required this.description,
    required this.stars,
    required this.forks,
  });

  factory RepositoryModel.fromJson(Map<String, dynamic> json) {
    return RepositoryModel(
      name: json['name'],
      owner: json['owner']['login'],
      description: json['description'],
      stars: json['stargazers_count'],
      forks: json['forks_count'],
    );
  }
}