import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:gitgub_api_app/data/sources/remote_data_source.dart';
import 'dart:convert';

class MockClient extends Mock implements http.Client {}

void main() {
  late RemoteDataSource dataSource;
  late http.Client mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = RemoteDataSource(client: mockClient);
  });

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  const mockRepositoryJson = {
    'name': 'flutter',
    'owner': {
      'login': 'flutter',
    },
    'description': 'Flutter makes it easy and fast to build beautiful apps for mobile and beyond.',
    'stargazers_count': 100000,
    'forks_count': 50000,
  };

  const mockRepositoryListJson = {
    'items': [mockRepositoryJson]
  };

  const mockIssueOrPRJson = {
    'id': 1,
    'title': 'Example Issue',
    'body': 'This is a description of the issue.',
    'html_url': 'https://github.com/flutter/flutter/issues/1',
    'state': 'open',
    'pull_request': null,
  };

  const mockIssueOrPRListJson = [mockIssueOrPRJson];

  group('RemoteDataSource', () {
    test('searchRepositories returns valid data', () async {
      final response = http.Response(jsonEncode(mockRepositoryListJson), 200);

      when(() => mockClient.get(any())).thenAnswer((_) async => response);

      final result = await dataSource.searchRepositories('flutter');
      expect(result, isNotEmpty);
    });

    test('getRepositoryDetail returns valid data', () async {
      final response = http.Response(jsonEncode(mockRepositoryJson), 200);

      when(() => mockClient.get(any())).thenAnswer((_) async => response);

      final result = await dataSource.getRepositoryDetail('flutter', 'flutter');
      expect(result, isNotNull);
    });

    test('getIssuesOrPRs returns valid data', () async {
      final response = http.Response(jsonEncode(mockIssueOrPRListJson), 200);

      when(() => mockClient.get(any())).thenAnswer((_) async => response);

      final result = await dataSource.getIssuesOrPRs('flutter', 'flutter');
      expect(result, isNotEmpty);
    });
  });
}
