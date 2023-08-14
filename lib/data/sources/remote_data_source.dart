import 'package:gitgub_api_app/data/models/repository_model.dart';
import 'package:gitgub_api_app/data/models/issue_pr_model.dart';
import 'package:gitgub_api_app/utils/sort_util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RemoteDataSource {
  final http.Client client;
  final baseUrl = 'https://api.github.com';

  RemoteDataSource({required this.client});

  Future<List<RepositoryModel>> searchRepositories(String keyword,
      {int page = 1, RepoSort? sort, SortOrder? order}) async {
    String sortParam = sort != null ? sort.name : '';
    String orderParam = order != null ? order.name : '';

    final response = await client.get(Uri.parse(
        '$baseUrl/search/repositories?q=$keyword&page=$page${sortParam.isNotEmpty ? '&sort=$sortParam' : ''}${orderParam.isNotEmpty ? '&order=$orderParam' : ''}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> items = data['items'];
      return items.map((item) => RepositoryModel.fromJson(item)).toList();
    } else {
      throw Exception(
          'Failed to load repositories. Status Code: ${response.statusCode}, Response: ${response.body}');
    }
  }

  Future<RepositoryModel> getRepositoryDetail(
      String owner, String repoName) async {
    final response =
        await client.get(Uri.parse('$baseUrl/repos/$owner/$repoName'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return RepositoryModel.fromJson(data);
    } else {
      throw Exception('Failed to load repository details');
    }
  }

  Future<List<IssueOrPRModel>> getIssuesOrPRs(
      String owner, String repoName) async {
    final response =
        await client.get(Uri.parse('$baseUrl/repos/$owner/$repoName/issues'));
    if (response.statusCode == 200) {
      final List<dynamic> issues = json.decode(response.body);
      return issues.map((issue) => IssueOrPRModel.fromJson(issue)).toList();
    } else {
      throw Exception('Failed to load issues or PRs');
    }
  }
}
