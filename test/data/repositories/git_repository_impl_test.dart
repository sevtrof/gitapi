import 'package:gitgub_api_app/data/models/issue_pr_model.dart';
import 'package:gitgub_api_app/data/models/repository_model.dart';
import 'package:gitgub_api_app/data/repositories/git_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gitgub_api_app/data/sources/remote_data_source.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

void main() {
  late GithubRepositoryImpl repository;
  late RemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = GithubRepositoryImpl(mockRemoteDataSource);
  });

  group('GithubRepositoryImpl Tests', () {
    test('searchRepositories returns valid data', () async {
      final mockResponse = [
        RepositoryModel(
            name: '', owner: '', description: '', stars: 0, forks: 0)
      ];
      when(() => mockRemoteDataSource.searchRepositories(any(),
          page: any(named: 'page'))).thenAnswer((_) async => mockResponse);

      final result = await repository.searchRepositories('flutter');
      expect(result, isNotEmpty);
    });

    test('getRepositoryDetail returns valid data', () async {
      final mockResponse = RepositoryModel(
          name: '', owner: '', description: '', stars: 0, forks: 0);
      when(() => mockRemoteDataSource.getRepositoryDetail(any(), any()))
          .thenAnswer((_) async => mockResponse);

      final result = await repository.getRepositoryDetail('flutter', 'flutter');
      expect(result, isNotNull);
    });

    test('getIssuesOrPRs returns valid data', () async {
      final mockResponse = [
        IssueOrPRModel(
            id: 1,
            title: '',
            body: '',
            htmlUrl: '',
            state: '',
            isPullRequest: false)
      ];
      when(() => mockRemoteDataSource.getIssuesOrPRs(any(), any()))
          .thenAnswer((_) async => mockResponse);

      final result = await repository.getIssuesOrPRs('flutter', 'flutter');
      expect(result, isNotEmpty);
    });
  });
}
