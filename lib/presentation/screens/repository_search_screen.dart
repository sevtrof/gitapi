import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gitgub_api_app/domain/entities/repository.dart';
import 'package:gitgub_api_app/domain/usecases/get_repository_details.dart';
import 'package:gitgub_api_app/domain/usecases/get_repository_issues_pr.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_detail/repository_detail_bloc.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_search/repository_search_bloc.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_search/repository_search_event.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_search/repository_search_state.dart';
import 'package:gitgub_api_app/presentation/screens/repository_details_screen.dart';
import 'package:rxdart/rxdart.dart';

class RepositorySearchScreen extends StatefulWidget {
  const RepositorySearchScreen({Key? key}) : super(key: key);

  @override
  RepositorySearchScreenState createState() => RepositorySearchScreenState();
}

class RepositorySearchScreenState extends State<RepositorySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final PublishSubject<String> _searchSubject = PublishSubject<String>();
  double previousOffset = 0.0;
  String _currentSort = 'Stars';

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    _searchSubject
        .debounceTime(const Duration(milliseconds: 500))
        .listen((searchTerm) {
      context
          .read<RepositorySearchBloc>()
          .add(SearchKeywordEntered(searchTerm));
      context.read<RepositorySearchBloc>().add(SortRepositories(_currentSort));
    });
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        previousOffset = _scrollController.offset;
        context.read<RepositorySearchBloc>().add(FetchMoreRepositories());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search GitHub Repositories")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchTextField(
                controller: _searchController,
                onChanged: (value) => _searchSubject.add(value)),
            const SizedBox(height: 10),
            SortDropdown(
              value: _currentSort,
              onChanged: (newValue) {
                setState(() => _currentSort = newValue);
                context
                    .read<RepositorySearchBloc>()
                    .add(SortRepositories(_currentSort));
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<RepositorySearchBloc, RepositorySearchState>(
                builder: _buildSearchStateView,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchStateView(BuildContext context, RepositorySearchState state) {
    if (state is SearchInitial) {
      return const Center(child: Text("Enter a keyword to start searching."));
    } else if (state is Searching && state.previousRepositories != null) {
      return _buildListView(state.previousRepositories!);
    } else if (state is Searching) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is SearchCompleted) {
      return _buildListView(state.repositories);
    } else if (state is SearchError) {
      return const Center(child: Text("An error occurred."));
    }
    return const SizedBox.shrink();
  }

  Widget _buildListView(List<Repository> repositories) {
    return ListView.builder(
      key: const PageStorageKey('myListView'),
      controller: _scrollController,
      itemCount: repositories.length + 1,
      itemBuilder: (context, index) {
        if (index >= repositories.length) {
          return const Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(strokeWidth: 5.0),
            ),
          );
        }

        return RepositoryListItem(
          repository: repositories[index],
          onTap: () => _navigateToDetail(context, repositories[index]),
        );
      },
    );
  }

  void _navigateToDetail(BuildContext context, Repository repository) {
    final getRepositoryDetail = GetIt.I.get<GetRepositoryDetail>();
    final getIssuesOrPRsUsecase = GetIt.I.get<GetIssuesOrPRsUsecase>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<RepositoryDetailBloc>(
          create: (context) => RepositoryDetailBloc(
              getRepositoryDetail: getRepositoryDetail,
              getIssuesOrPRsUsecase: getIssuesOrPRsUsecase),
          child: RepositoryDetailScreen(summaryRepo: repository),
        ),
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchTextField(
      {super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Enter a keyword',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            context
                .read<RepositorySearchBloc>()
                .add(SearchKeywordEntered(controller.text));
          },
        ),
      ),
    );
  }
}

class SortDropdown extends StatelessWidget {
  final String value;
  final Function(String) onChanged;

  const SortDropdown({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      onChanged: (newValue) => onChanged(newValue!),
      items: <String>[
        'Stars',
        'Name Ascending',
        'Name Descending',
        'Forks'
      ].map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
          .toList(),
    );
  }
}


class RepositoryListItem extends StatelessWidget {
  final Repository repository;
  final Function() onTap;

  const RepositoryListItem(
      {super.key, required this.repository, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          repository.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(repository.owner),
            const SizedBox(height: 4),
            Text(repository.description ?? ""),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, size: 20.0, color: Colors.yellow),
                const SizedBox(width: 4),
                Text('${repository.stars}'),
                const SizedBox(width: 12),
                const Icon(Icons.call_split,
                    size: 20.0, color: Colors.blueGrey),
                const SizedBox(width: 4),
                Text('${repository.forks}'),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14.0),
        onTap: onTap,
      ),
    );
  }
}
