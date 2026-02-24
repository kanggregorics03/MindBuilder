import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/json_utils.dart';
import '../data/app_database.dart';
import '../data/entry_repository.dart';
import 'builder_wizard_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.repository, super.key});

  static const String routeName = '/';

  final EntryRepository repository;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy.MM.dd HH:mm');
    return Scaffold(
      appBar: AppBar(title: const Text('Mind Builder')),
      body: StreamBuilder<List<Entry>>(
        stream: repository.watchRecentEntries(limit: 20),
        builder: (BuildContext context, AsyncSnapshot<List<Entry>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = snapshot.data ?? const <Entry>[];
          if (entries.isEmpty) {
            return const _EmptyState();
          }

          return ListView.separated(
            itemCount: entries.length,
            separatorBuilder: (_, int index) => const Divider(height: 1),
            itemBuilder: (BuildContext context, int index) {
              final entry = entries[index];
              final tags = decodeJsonStringList(entry.situationTagsJson);
              final preview = _preview(entry.negativeText);
              return ListTile(
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushNamed(DetailScreen.routeName, arguments: entry.id);
                },
                title: Text(
                  '${formatter.format(entry.createdAt)}  ${tags.join(", ")}',
                ),
                subtitle: Text(preview),
                trailing: const Icon(Icons.chevron_right),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(BuilderWizardScreen.routeName);
        },
        icon: const Icon(Icons.edit_note),
        label: const Text('2분 정리하기'),
      ),
    );
  }

  String _preview(String text) {
    final value = text.replaceAll('\n', ' ').trim();
    if (value.length <= 30) {
      return value;
    }
    return '${value.substring(0, 30)}...';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Icon(Icons.inbox_outlined, size: 40),
          SizedBox(height: 12),
          Text('저장된 기록이 없습니다.'),
          SizedBox(height: 8),
          Text('오른쪽 아래 버튼으로 첫 기록을 시작하세요.'),
        ],
      ),
    );
  }
}
