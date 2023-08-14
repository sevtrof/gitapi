import 'package:equatable/equatable.dart';
import 'package:gitgub_api_app/domain/entities/repository.dart';

abstract class RepositorySearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends RepositorySearchState {}

class Searching extends RepositorySearchState {
  final List<Repository>? previousRepositories;

  Searching({this.previousRepositories});

  @override
  List<Object?> get props => [previousRepositories];
}

class SearchCompleted extends RepositorySearchState {
  final List<Repository> repositories;
  final bool hasReachedMax;

  SearchCompleted({
    required this.repositories,
    this.hasReachedMax = false,
  });

  SearchCompleted copyWith({
    List<Repository>? repositories,
    bool? hasReachedMax,
  }) {
    return SearchCompleted(
      repositories: repositories ?? this.repositories,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [repositories, hasReachedMax];
}

class SearchError extends RepositorySearchState {}
