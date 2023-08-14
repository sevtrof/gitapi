import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitgub_api_app/domain/entities/repository.dart';
import 'package:gitgub_api_app/domain/usecases/search_repositories_usecase.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_search/repository_search_event.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_search/repository_search_state.dart';
import 'package:gitgub_api_app/utils/sort_util.dart';

class RepositorySearchBloc
    extends Bloc<RepositorySearchEvent, RepositorySearchState> {
  final SearchRepositories searchRepositories;

  RepositorySearchBloc({required this.searchRepositories})
      : super(SearchInitial()) {
    on<SearchKeywordEntered>(mapSearchKeywordToState);
    on<FetchMoreRepositories>(mapSearchKeywordToState);
    on<SortRepositories>(mapSearchKeywordToState);
  }

  int currentPage = 1;
  String currentKeyword = '';
  RepoSort? currentSort = RepoSort.stars;
  SortOrder? currentOrder = SortOrder.desc;

  void mapSearchKeywordToState(
      RepositorySearchEvent event,
      Emitter<RepositorySearchState> emit,
      ) async {
    List<Repository> currentList = getCurrentList(event);

    emit(Searching(previousRepositories: currentList));

    try {
      final newRepositories = await fetchRepositories();
      currentList.addAll(newRepositories);
      sortRepositoriesIfNeeded(event, currentList);
      emit(SearchCompleted(repositories: currentList));

      updatePageIfNeeded(event);
    } catch (e) {
      emit(SearchError());
    }
  }

  List<Repository> getCurrentList(RepositorySearchEvent event) {
    List<Repository> currentList = [];

    if (event is SearchKeywordEntered) {
      currentKeyword = event.keyword;
      currentPage = 1;
    } else if (state is SearchCompleted) {
      currentList = (state as SearchCompleted).repositories;
    }

    return currentList;
  }

  Future<List<Repository>> fetchRepositories() async {
    return await searchRepositories(
      currentKeyword,
      page: currentPage,
      sort: currentSort,
      order: currentOrder,
    );
  }

  void sortRepositoriesIfNeeded(
      RepositorySearchEvent event, List<Repository> repositories) {
    if (event is SortRepositories) {
      switch (event.sortType) {
        case 'Stars':
          repositories.sort((a, b) => b.stars.compareTo(a.stars));
          break;
        case 'Name Ascending':
          repositories.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'Name Descending':
          repositories.sort((a, b) => b.name.compareTo(a.name));
          break;
        case 'Forks':
          repositories.sort((a, b) => b.forks.compareTo(a.forks));
          break;
      }
    }
  }

  void updatePageIfNeeded(RepositorySearchEvent event) {
    if (event is SearchKeywordEntered || event is FetchMoreRepositories) {
      currentPage++;
    }
  }
}
