import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitgub_api_app/domain/entities/repository.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_search/repository_search_event.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_search/repository_search_state.dart';
import 'package:gitgub_api_app/presentation/screens/repository_search_screen.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_search/repository_search_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockRepositorySearchBloc extends Mock implements RepositorySearchBloc {
  @override
  Stream<RepositorySearchState> get stream =>
      const Stream<RepositorySearchState>.empty();

  @override
  Future<void> close() async {}
}

class FakeRepositorySearchEvent extends Fake implements RepositorySearchEvent {}

class FakeRepositorySearchState extends Fake implements RepositorySearchState {}

void main() {
  late RepositorySearchBloc mockRepositorySearchBloc;

  setUpAll(() {
    registerFallbackValue(FakeRepositorySearchEvent());
    registerFallbackValue(FakeRepositorySearchState());
  });

  setUp(() {
    mockRepositorySearchBloc = MockRepositorySearchBloc();
  });

  tearDown(() {
    mockRepositorySearchBloc.close();
  });

  testWidgets('should show initial text when in SearchInitial state',
      (tester) async {
    when(() => mockRepositorySearchBloc.state).thenReturn(SearchInitial());

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider.value(
        value: mockRepositorySearchBloc,
        child: const RepositorySearchScreen(),
      ),
    ));

    expect(find.text("Enter a keyword to start searching."), findsOneWidget);
  });

  testWidgets(
      'should show circular progress indicator when in Searching state without previous repositories',
      (tester) async {
    when(() => mockRepositorySearchBloc.state).thenReturn(Searching());

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider.value(
        value: mockRepositorySearchBloc,
        child: const RepositorySearchScreen(),
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show initial text when in SearchInitial state',
      (tester) async {
    when(() => mockRepositorySearchBloc.state).thenReturn(SearchInitial());

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider.value(
        value: mockRepositorySearchBloc,
        child: const RepositorySearchScreen(),
      ),
    ));

    expect(find.text("Enter a keyword to start searching."), findsOneWidget);
  });

  testWidgets(
      'should show circular progress indicator when in Searching state without previous repositories',
      (tester) async {
    when(() => mockRepositorySearchBloc.state).thenReturn(Searching());

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider.value(
        value: mockRepositorySearchBloc,
        child: const RepositorySearchScreen(),
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets(
      'should show previous repositories and a progress indicator when in Searching state with previous repositories',
      (tester) async {
    final List<Repository> mockPreviousRepositories = [
      const Repository(
          name: "PrevRepo1",
          description: "Prev Repo1",
          owner: '',
          stars: 0,
          forks: 0)
    ];

    when(() => mockRepositorySearchBloc.state)
        .thenReturn(Searching(previousRepositories: mockPreviousRepositories));

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider.value(
        value: mockRepositorySearchBloc,
        child: const RepositorySearchScreen(),
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text("PrevRepo1"), findsOneWidget);
  });

  testWidgets('should show repository list when in SearchCompleted state',
      (tester) async {
    final List<Repository> mockRepositories = [
      const Repository(
          name: "Repo1",
          description: "Test Repo1",
          owner: '',
          stars: 0,
          forks: 0)
    ];

    when(() => mockRepositorySearchBloc.state)
        .thenReturn(SearchCompleted(repositories: mockRepositories));

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider.value(
        value: mockRepositorySearchBloc,
        child: const RepositorySearchScreen(),
      ),
    ));

    expect(find.text("Repo1"), findsOneWidget);
  });


  testWidgets('should show error text when in SearchError state',
      (tester) async {
    when(() => mockRepositorySearchBloc.state).thenReturn(SearchError());

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider.value(
        value: mockRepositorySearchBloc,
        child: const RepositorySearchScreen(),
      ),
    ));

    expect(find.text("An error occurred."), findsOneWidget);
  });
}
