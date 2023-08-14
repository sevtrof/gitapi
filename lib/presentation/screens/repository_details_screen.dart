import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitgub_api_app/domain/entities/issue_pr.dart';
import 'package:gitgub_api_app/domain/entities/repository.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_detail/repository_detail_bloc.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_detail/repository_detail_event.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_detail/repository_detail_state.dart';

class RepositoryDetailScreen extends StatelessWidget {
  final Repository summaryRepo;

  const RepositoryDetailScreen({super.key, required this.summaryRepo});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RepositoryDetailBloc>();
    bloc.add(FetchRepositoryDetail(summaryRepo.owner, summaryRepo.name));

    return Scaffold(
      appBar: AppBar(title: Text(summaryRepo.name)),
      body: BlocBuilder<RepositoryDetailBloc, RepositoryDetailState>(
        builder: (context, state) {
          if (state is DetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DetailLoaded) {
            return _DetailContentView(
                repository: state.repository, issuesOrPRs: state.issuesOrPRs);
          } else if (state is DetailError) {
            return Center(child: Text("An error occurred: ${state.message}"));
          }
          return Container();
        },
      ),
    );
  }
}

class _DetailContentView extends StatelessWidget {
  final Repository repository;
  final List<IssueOrPR> issuesOrPRs;

  const _DetailContentView(
      {required this.repository, required this.issuesOrPRs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            repository.name,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            repository.owner,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text(repository.description),
          const Divider(height: 30, thickness: 2),
          const Text("Issues and PRs:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ..._buildIssueOrPRList(issuesOrPRs, theme),
        ],
      ),
    );
  }

  List<Widget> _buildIssueOrPRList(
      List<IssueOrPR> issuesOrPRs, ThemeData theme) {
    final issueOrPRWidgets = <Widget>[];

    for (var i = 0; i < issuesOrPRs.length; i++) {
      issueOrPRWidgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Text(issuesOrPRs[i].title, style: theme.textTheme.titleMedium),
          subtitle:
              Text(issuesOrPRs[i].description),
        ),
      ));
      if (i != issuesOrPRs.length - 1) {
        issueOrPRWidgets.add(const Divider());
      }
    }

    return issueOrPRWidgets;
  }
}
