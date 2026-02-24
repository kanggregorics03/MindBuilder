import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/json_utils.dart';
import '../data/app_database.dart';
import '../data/entry_repository.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    required this.repository,
    required this.entryId,
    super.key,
  });

  static const String routeName = '/detail';

  final EntryRepository repository;
  final int entryId;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Entry?> _entryFuture;

  @override
  void initState() {
    super.initState();
    _entryFuture = widget.repository.getEntry(widget.entryId);
  }

  Future<void> _deleteEntry() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제 확인'),
          content: const Text('이 기록을 삭제할까요?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await widget.repository.deleteEntry(widget.entryId);
    debugPrint('entry_deleted:${widget.entryId}');
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy.MM.dd HH:mm');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry 상세'),
        actions: <Widget>[
          IconButton(
            onPressed: _deleteEntry,
            icon: const Icon(Icons.delete_outline),
            tooltip: '삭제',
          ),
        ],
      ),
      body: FutureBuilder<Entry?>(
        future: _entryFuture,
        builder: (BuildContext context, AsyncSnapshot<Entry?> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final entry = snapshot.data;
          if (entry == null) {
            return const Center(child: Text('기록을 찾을 수 없습니다.'));
          }

          final tags = decodeJsonStringList(entry.situationTagsJson);
          final distortions = decodeJsonStringList(entry.distortionsJson);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              _Section(
                title: '기본 정보',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('생성 시각: ${formatter.format(entry.createdAt)}'),
                    const SizedBox(height: 8),
                    Text('태그: ${tags.join(", ")}'),
                    if (entry.situationNote != null &&
                        entry.situationNote!.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('상황 메모: ${entry.situationNote}'),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Section(
                title: '부정적 생각',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('템플릿: ${entry.negativeTemplateId}'),
                    const SizedBox(height: 8),
                    Text(entry.negativeText),
                    if (entry.negativeConfidence != null) ...[
                      const SizedBox(height: 8),
                      Text('확신: ${entry.negativeConfidence}'),
                    ],
                    if (entry.negativeFrequency != null) ...[
                      const SizedBox(height: 8),
                      Text('빈도: ${entry.negativeFrequency}'),
                    ],
                    const SizedBox(height: 8),
                    Text('왜곡(JSON): ${distortions.join(", ")}'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Section(
                title: '균형 생각',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('템플릿: ${entry.balancedTemplateId}'),
                    const SizedBox(height: 8),
                    Text(entry.balancedText),
                    if (entry.emotionBefore != null) ...[
                      const SizedBox(height: 8),
                      Text('감정 전: ${entry.emotionBefore}'),
                    ],
                    if (entry.emotionAfter != null) ...[
                      const SizedBox(height: 8),
                      Text('감정 후: ${entry.emotionAfter}'),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
