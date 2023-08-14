import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gitgub_api_app/domain/entities/repository.dart';
import 'package:gitgub_api_app/domain/usecases/search_repositories_usecase.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_search/repository_search_bloc.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_search/repository_search_event.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_search/repository_search_state.dart';

class MockSearchRepositories extends Mock implements SearchRepositories {}

void main() {
  late RepositorySearchBloc bloc;
  late MockSearchRepositories mockSearchRepositories;

  setUp(() {
    registerFallbackValue('test');
    registerFallbackValue(0);

    mockSearchRepositories = MockSearchRepositories();
    bloc = RepositorySearchBloc(searchRepositories: mockSearchRepositories);
  });

  tearDown(() {
    bloc.close();
  });

  test('Initial state is correct', () {
    expect(bloc.state, equals(SearchInitial()));
  });

  test(
      'Emits [Searching, SearchCompleted] when SearchKeywordEntered is added and search succeeds',
      () async {
    when(() =>
        mockSearchRepositories('test',
            page: any(named: 'page'),
            sort: any(named: 'sort'),
            order: any(named: 'order'))).thenAnswer((_) async => [
          const Repository(
            name: 'testRepo',
            description: 'desc',
            stars: 10,
            forks: 5,
            owner: '',
          )
        ]);

    final emittedStates = <RepositorySearchState>[];

    final subscription = bloc.stream.listen(emittedStates.add);

    bloc.add(SearchKeywordEntered('test'));

    await Future.delayed(const Duration(seconds: 1));

    subscription.cancel();

    expect(emittedStates, [
      Searching(previousRepositories: const [
        Repository(
          name: 'testRepo',
          description: 'desc',
          stars: 10,
          forks: 5,
          owner: '',
        )
      ]),
      SearchCompleted(repositories: const [
        Repository(
          name: 'testRepo',
          description: 'desc',
          stars: 10,
          forks: 5,
          owner: '',
        )
      ])
    ]);

    bloc.close();
  });

  test('Emits [Searching, SearchError] when an exception is thrown', () async {
    when(() => mockSearchRepositories('test',
        page: any(named: 'page'),
        sort: any(named: 'sort'),
        order: any(named: 'order'))).thenThrow(Exception());

    bloc.add(SearchKeywordEntered('test'));

    final expectedResponse = [
      Searching(previousRepositories: const []),
      SearchError(),
    ];

    await expectLater(
        bloc.stream,
        emitsInOrder(expectedResponse));
  });
}
