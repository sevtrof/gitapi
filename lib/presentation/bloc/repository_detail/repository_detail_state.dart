import 'package:equatable/equatable.dart';
import 'package:gitgub_api_app/domain/entities/issue_pr.dart';
import 'package:gitgub_api_app/domain/entities/repository.dart';

abstract class RepositoryDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DetailInitial extends RepositoryDetailState {}

class DetailLoading extends RepositoryDetailState {}

class DetailLoaded extends RepositoryDetailState {
  final Repository repository;
  final List<IssueOrPR> issuesOrPRs;

  DetailLoaded(this.repository, this.issuesOrPRs);

  @override
  List<Object?> get props => [repository, issuesOrPRs];
}

class DetailError extends RepositoryDetailState {
  final String message;

  DetailError(this.message);

  @override
  List<Object?> get props => [message];
}
