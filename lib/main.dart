import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitgub_api_app/di/service_locator.dart';
import 'package:gitgub_api_app/domain/usecases/search_repositories_usecase.dart';
import 'package:gitgub_api_app/presentation/bloc/repository_search/repository_search_bloc.dart';
import 'package:gitgub_api_app/presentation/screens/repository_search_screen.dart';
import 'package:get_it/get_it.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Repo Search',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => RepositorySearchBloc(
            searchRepositories: GetIt.I.get<SearchRepositories>()),
        child: const RepositorySearchScreen(),
      ),
    );
  }
}
