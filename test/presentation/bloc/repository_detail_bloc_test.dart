import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gitgub_api_app/domain/entities/issue_pr.dart';
import 'package:gitgub_api_app/domain/entities/repository.dart';
import 'package:gitgub_api_app/domain/usecases/get_repository_details.dart';
import 'package:gitgub_api_app/domain/usecases/get_repository_issues_pr.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_detail/repository_detail_bloc.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_detail/repository_detail_event.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_detail/repository_detail_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetRepositoryDetail extends Mock implements GetRepositoryDetail {}

class MockGetIssuesOrPRsUsecase extends Mock implements GetIssuesOrPRsUsecase {}

class FakeRepository extends Fake implements Repository {}

class FakeIssueOrPRModel extends Fake implements IssueOrPR {}

void main() {
  late RepositoryDetailBloc bloc;
  late MockGetRepositoryDetail mockGetRepositoryDetail;
  late MockGetIssuesOrPRsUsecase mockGetIssuesOrPRsUsecase;

  setUp(() {
    mockGetRepositoryDetail = MockGetRepositoryDetail();
    mockGetIssuesOrPRsUsecase = MockGetIssuesOrPRsUsecase();
    bloc = RepositoryDetailBloc(
      getRepositoryDetail: mockGetRepositoryDetail,
      getIssuesOrPRsUsecase: mockGetIssuesOrPRsUsecase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('Emits [DetailLoading, DetailLoaded] when data fetch is successful',
      () async {
    final mockRepo = FakeRepository();
    final mockIssuesOrPRs = [FakeIssueOrPRModel(), FakeIssueOrPRModel()];

    when(() => mockGetRepositoryDetail(any(), any()))
        .thenAnswer((_) async => mockRepo);
    when(() => mockGetIssuesOrPRsUsecase(any(), any()))
        .thenAnswer((_) async => mockIssuesOrPRs);

    final emittedStates = <RepositoryDetailState>[];

    final subscription = bloc.stream.listen(emittedStates.add);

    bloc.add(FetchRepositoryDetail("sampleOwner", "sampleRepo"));

    await Future.delayed(const Duration(milliseconds: 100));

    subscription.cancel();

    expect(emittedStates, [
      DetailLoading(),
      DetailLoaded(mockRepo, mockIssuesOrPRs),
    ]);
  });

  test('Emits [DetailLoading, DetailError] when an exception is thrown',
      () async {
    when(() => mockGetRepositoryDetail(any(), any()))
        .thenThrow(Exception("Test error"));

    final emittedStates = <RepositoryDetailState>[];

    final subscription = bloc.stream.listen(emittedStates.add);

    bloc.add(FetchRepositoryDetail("sampleOwner", "sampleRepo"));

    await Future.delayed(const Duration(milliseconds: 100));

    subscription.cancel();

    expect(emittedStates, [
      DetailLoading(),
      DetailError("Exception: Test error"),
    ]);
  });
}
