abstract class RepositorySearchEvent {}

class SearchKeywordEntered extends RepositorySearchEvent {
  final String keyword;

  SearchKeywordEntered(this.keyword);
}

class FetchMoreRepositories extends RepositorySearchEvent {}

class SortRepositories extends RepositorySearchEvent {
  final String sortType;

  SortRepositories(this.sortType);
}
