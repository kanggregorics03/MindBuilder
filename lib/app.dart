import 'package:flutter/material.dart';

import 'features/entry/data/app_database.dart';
import 'features/entry/data/entry_repository.dart';
import 'features/entry/ui/builder_wizard_screen.dart';
import 'features/entry/ui/detail_screen.dart';
import 'features/entry/ui/home_screen.dart';

class MindBuilderApp extends StatefulWidget {
  const MindBuilderApp({super.key});

  @override
  State<MindBuilderApp> createState() => _MindBuilderAppState();
}

class _MindBuilderAppState extends State<MindBuilderApp> {
  late final AppDatabase _database;
  late final EntryRepository _repository;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _repository = EntryRepository(_database);
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.routeName:
        return MaterialPageRoute<void>(
          builder: (_) => HomeScreen(repository: _repository),
        );
      case BuilderWizardScreen.routeName:
        return MaterialPageRoute<void>(
          builder: (_) => BuilderWizardScreen(repository: _repository),
        );
      case DetailScreen.routeName:
        final argument = settings.arguments;
        if (argument is int) {
          return MaterialPageRoute<void>(
            builder: (_) =>
                DetailScreen(repository: _repository, entryId: argument),
          );
        }
        return MaterialPageRoute<void>(
          builder: (_) => const _RouteErrorScreen(),
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const _RouteErrorScreen(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mind Builder',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      onGenerateRoute: _onGenerateRoute,
      initialRoute: HomeScreen.routeName,
    );
  }
}

class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('경로 오류')),
      body: const Center(child: Text('잘못된 경로 인자입니다.')),
    );
  }
}
