import 'package:drift/drift.dart';

import '../../../core/utils/json_utils.dart';
import '../domain/entry_draft.dart';
import 'app_database.dart';

class EntryRepository {
  EntryRepository(this._database);

  final AppDatabase _database;

  Stream<List<Entry>> watchRecentEntries({int limit = 20}) {
    final query = _database.select(_database.entries)
      ..orderBy(<OrderingTerm Function(Entries)>[
        (Entries table) => OrderingTerm.desc(table.createdAt),
        (Entries table) => OrderingTerm.desc(table.id),
      ])
      ..limit(limit);
    return query.watch();
  }

  Future<Entry?> getEntry(int id) {
    return (_database.select(
      _database.entries,
    )..where((Entries table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertEntry(EntryDraft draft) {
    if (!draft.hasMinimumRequirements) {
      throw ArgumentError('Draft is missing required fields.');
    }

    return _database
        .into(_database.entries)
        .insert(
          EntriesCompanion.insert(
            createdAt: draft.createdAt ?? DateTime.now(),
            situationTagsJson: encodeJsonStringList(draft.situationTags),
            situationNote: Value(draft.situationNote),
            negativeTemplateId: _normalizeTemplateId(draft.negativeTemplateId),
            negativeText: draft.negativeText.trim(),
            negativeConfidence: Value(
              _normalizeRange(draft.negativeConfidence, 0, 100),
            ),
            negativeFrequency: Value(
              _normalizeFrequency(draft.negativeFrequency),
            ),
            distortionsJson: encodeJsonStringList(draft.distortions),
            balancedTemplateId: _normalizeTemplateId(draft.balancedTemplateId),
            balancedText: draft.balancedText.trim(),
            emotionBefore: Value(_normalizeRange(draft.emotionBefore, 0, 10)),
            emotionAfter: Value(_normalizeRange(draft.emotionAfter, 0, 10)),
          ),
        );
  }

  Future<void> deleteEntry(int id) {
    return (_database.delete(
      _database.entries,
    )..where((Entries table) => table.id.equals(id))).go();
  }

  String _normalizeTemplateId(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return 'FREE_TEXT';
    }
    return normalized;
  }

  int? _normalizeRange(int? value, int min, int max) {
    if (value == null) {
      return null;
    }
    return value.clamp(min, max);
  }

  String? _normalizeFrequency(String? value) {
    const allowed = <String>{'항상', '자주', '가끔'};
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (!allowed.contains(value)) {
      return null;
    }
    return value;
  }
}
