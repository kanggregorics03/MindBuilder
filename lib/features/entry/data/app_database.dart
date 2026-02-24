import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Entries extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get createdAt => dateTime()();

  TextColumn get situationTagsJson => text()();

  TextColumn get situationNote => text().nullable()();

  TextColumn get negativeTemplateId => text()();

  TextColumn get negativeText => text()();

  IntColumn get negativeConfidence => integer().nullable()();

  TextColumn get negativeFrequency => text().nullable()();

  TextColumn get distortionsJson => text()();

  TextColumn get balancedTemplateId => text()();

  TextColumn get balancedText => text()();

  IntColumn get emotionBefore => integer().nullable()();

  IntColumn get emotionAfter => integer().nullable()();
}

@DriftDatabase(tables: <Type>[Entries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final file = File('${appDirectory.path}/mind_builder.sqlite');
    return NativeDatabase.createInBackground(file);
  });
}
