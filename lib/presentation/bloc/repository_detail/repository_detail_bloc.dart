import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitgub_api_app/domain/usecases/get_repository_details.dart';
import 'package:gitgub_api_app/domain/usecases/get_repository_issues_pr.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_detail/repository_detail_event.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_detail/repository_detail_state.dart';

class RepositoryDetailBloc
    extends Bloc<RepositoryDetailEvent, RepositoryDetailState> {
  final GetRepositoryDetail getRepositoryDetail;
  final GetIssuesOrPRsUsecase getIssuesOrPRsUsecase;

  RepositoryDetailBloc(
      {required this.getRepositoryDetail, required this.getIssuesOrPRsUsecase})
      : super(DetailInitial()) {
    on<FetchRepositoryDetail>(_mapFetchDetailToState);
  }

  Future<void> _mapFetchDetailToState(
    FetchRepositoryDetail event,
    Emitter<RepositoryDetailState> emit,
  ) async {
    emit(DetailLoading());
    try {
      final repository = await getRepositoryDetail(event.owner, event.repoName);
      final issuesOrPRs =
          await getIssuesOrPRsUsecase(event.owner, event.repoName);
      emit(DetailLoaded(repository, issuesOrPRs));
    } catch (error) {
      emit(DetailError(error.toString()));
    }
  }
}
