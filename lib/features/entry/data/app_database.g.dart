// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EntriesTable extends Entries with TableInfo<$EntriesTable, Entry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _situationTagsJsonMeta = const VerificationMeta(
    'situationTagsJson',
  );
  @override
  late final GeneratedColumn<String> situationTagsJson =
      GeneratedColumn<String>(
        'situation_tags_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _situationNoteMeta = const VerificationMeta(
    'situationNote',
  );
  @override
  late final GeneratedColumn<String> situationNote = GeneratedColumn<String>(
    'situation_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _negativeTemplateIdMeta =
      const VerificationMeta('negativeTemplateId');
  @override
  late final GeneratedColumn<String> negativeTemplateId =
      GeneratedColumn<String>(
        'negative_template_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _negativeTextMeta = const VerificationMeta(
    'negativeText',
  );
  @override
  late final GeneratedColumn<String> negativeText = GeneratedColumn<String>(
    'negative_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _negativeConfidenceMeta =
      const VerificationMeta('negativeConfidence');
  @override
  late final GeneratedColumn<int> negativeConfidence = GeneratedColumn<int>(
    'negative_confidence',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _negativeFrequencyMeta = const VerificationMeta(
    'negativeFrequency',
  );
  @override
  late final GeneratedColumn<String> negativeFrequency =
      GeneratedColumn<String>(
        'negative_frequency',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _distortionsJsonMeta = const VerificationMeta(
    'distortionsJson',
  );
  @override
  late final GeneratedColumn<String> distortionsJson = GeneratedColumn<String>(
    'distortions_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balancedTemplateIdMeta =
      const VerificationMeta('balancedTemplateId');
  @override
  late final GeneratedColumn<String> balancedTemplateId =
      GeneratedColumn<String>(
        'balanced_template_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _balancedTextMeta = const VerificationMeta(
    'balancedText',
  );
  @override
  late final GeneratedColumn<String> balancedText = GeneratedColumn<String>(
    'balanced_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emotionBeforeMeta = const VerificationMeta(
    'emotionBefore',
  );
  @override
  late final GeneratedColumn<int> emotionBefore = GeneratedColumn<int>(
    'emotion_before',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emotionAfterMeta = const VerificationMeta(
    'emotionAfter',
  );
  @override
  late final GeneratedColumn<int> emotionAfter = GeneratedColumn<int>(
    'emotion_after',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    situationTagsJson,
    situationNote,
    negativeTemplateId,
    negativeText,
    negativeConfidence,
    negativeFrequency,
    distortionsJson,
    balancedTemplateId,
    balancedText,
    emotionBefore,
    emotionAfter,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<Entry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('situation_tags_json')) {
      context.handle(
        _situationTagsJsonMeta,
        situationTagsJson.isAcceptableOrUnknown(
          data['situation_tags_json']!,
          _situationTagsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_situationTagsJsonMeta);
    }
    if (data.containsKey('situation_note')) {
      context.handle(
        _situationNoteMeta,
        situationNote.isAcceptableOrUnknown(
          data['situation_note']!,
          _situationNoteMeta,
        ),
      );
    }
    if (data.containsKey('negative_template_id')) {
      context.handle(
        _negativeTemplateIdMeta,
        negativeTemplateId.isAcceptableOrUnknown(
          data['negative_template_id']!,
          _negativeTemplateIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_negativeTemplateIdMeta);
    }
    if (data.containsKey('negative_text')) {
      context.handle(
        _negativeTextMeta,
        negativeText.isAcceptableOrUnknown(
          data['negative_text']!,
          _negativeTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_negativeTextMeta);
    }
    if (data.containsKey('negative_confidence')) {
      context.handle(
        _negativeConfidenceMeta,
        negativeConfidence.isAcceptableOrUnknown(
          data['negative_confidence']!,
          _negativeConfidenceMeta,
        ),
      );
    }
    if (data.containsKey('negative_frequency')) {
      context.handle(
        _negativeFrequencyMeta,
        negativeFrequency.isAcceptableOrUnknown(
          data['negative_frequency']!,
          _negativeFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('distortions_json')) {
      context.handle(
        _distortionsJsonMeta,
        distortionsJson.isAcceptableOrUnknown(
          data['distortions_json']!,
          _distortionsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_distortionsJsonMeta);
    }
    if (data.containsKey('balanced_template_id')) {
      context.handle(
        _balancedTemplateIdMeta,
        balancedTemplateId.isAcceptableOrUnknown(
          data['balanced_template_id']!,
          _balancedTemplateIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_balancedTemplateIdMeta);
    }
    if (data.containsKey('balanced_text')) {
      context.handle(
        _balancedTextMeta,
        balancedText.isAcceptableOrUnknown(
          data['balanced_text']!,
          _balancedTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_balancedTextMeta);
    }
    if (data.containsKey('emotion_before')) {
      context.handle(
        _emotionBeforeMeta,
        emotionBefore.isAcceptableOrUnknown(
          data['emotion_before']!,
          _emotionBeforeMeta,
        ),
      );
    }
    if (data.containsKey('emotion_after')) {
      context.handle(
        _emotionAfterMeta,
        emotionAfter.isAcceptableOrUnknown(
          data['emotion_after']!,
          _emotionAfterMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Entry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Entry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      situationTagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}situation_tags_json'],
      )!,
      situationNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}situation_note'],
      ),
      negativeTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}negative_template_id'],
      )!,
      negativeText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}negative_text'],
      )!,
      negativeConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}negative_confidence'],
      ),
      negativeFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}negative_frequency'],
      ),
      distortionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}distortions_json'],
      )!,
      balancedTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}balanced_template_id'],
      )!,
      balancedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}balanced_text'],
      )!,
      emotionBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}emotion_before'],
      ),
      emotionAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}emotion_after'],
      ),
    );
  }

  @override
  $EntriesTable createAlias(String alias) {
    return $EntriesTable(attachedDatabase, alias);
  }
}

class Entry extends DataClass implements Insertable<Entry> {
  final int id;
  final DateTime createdAt;
  final String situationTagsJson;
  final String? situationNote;
  final String negativeTemplateId;
  final String negativeText;
  final int? negativeConfidence;
  final String? negativeFrequency;
  final String distortionsJson;
  final String balancedTemplateId;
  final String balancedText;
  final int? emotionBefore;
  final int? emotionAfter;
  const Entry({
    required this.id,
    required this.createdAt,
    required this.situationTagsJson,
    this.situationNote,
    required this.negativeTemplateId,
    required this.negativeText,
    this.negativeConfidence,
    this.negativeFrequency,
    required this.distortionsJson,
    required this.balancedTemplateId,
    required this.balancedText,
    this.emotionBefore,
    this.emotionAfter,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['situation_tags_json'] = Variable<String>(situationTagsJson);
    if (!nullToAbsent || situationNote != null) {
      map['situation_note'] = Variable<String>(situationNote);
    }
    map['negative_template_id'] = Variable<String>(negativeTemplateId);
    map['negative_text'] = Variable<String>(negativeText);
    if (!nullToAbsent || negativeConfidence != null) {
      map['negative_confidence'] = Variable<int>(negativeConfidence);
    }
    if (!nullToAbsent || negativeFrequency != null) {
      map['negative_frequency'] = Variable<String>(negativeFrequency);
    }
    map['distortions_json'] = Variable<String>(distortionsJson);
    map['balanced_template_id'] = Variable<String>(balancedTemplateId);
    map['balanced_text'] = Variable<String>(balancedText);
    if (!nullToAbsent || emotionBefore != null) {
      map['emotion_before'] = Variable<int>(emotionBefore);
    }
    if (!nullToAbsent || emotionAfter != null) {
      map['emotion_after'] = Variable<int>(emotionAfter);
    }
    return map;
  }

  EntriesCompanion toCompanion(bool nullToAbsent) {
    return EntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      situationTagsJson: Value(situationTagsJson),
      situationNote: situationNote == null && nullToAbsent
          ? const Value.absent()
          : Value(situationNote),
      negativeTemplateId: Value(negativeTemplateId),
      negativeText: Value(negativeText),
      negativeConfidence: negativeConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(negativeConfidence),
      negativeFrequency: negativeFrequency == null && nullToAbsent
          ? const Value.absent()
          : Value(negativeFrequency),
      distortionsJson: Value(distortionsJson),
      balancedTemplateId: Value(balancedTemplateId),
      balancedText: Value(balancedText),
      emotionBefore: emotionBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(emotionBefore),
      emotionAfter: emotionAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(emotionAfter),
    );
  }

  factory Entry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Entry(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      situationTagsJson: serializer.fromJson<String>(json['situationTagsJson']),
      situationNote: serializer.fromJson<String?>(json['situationNote']),
      negativeTemplateId: serializer.fromJson<String>(
        json['negativeTemplateId'],
      ),
      negativeText: serializer.fromJson<String>(json['negativeText']),
      negativeConfidence: serializer.fromJson<int?>(json['negativeConfidence']),
      negativeFrequency: serializer.fromJson<String?>(
        json['negativeFrequency'],
      ),
      distortionsJson: serializer.fromJson<String>(json['distortionsJson']),
      balancedTemplateId: serializer.fromJson<String>(
        json['balancedTemplateId'],
      ),
      balancedText: serializer.fromJson<String>(json['balancedText']),
      emotionBefore: serializer.fromJson<int?>(json['emotionBefore']),
      emotionAfter: serializer.fromJson<int?>(json['emotionAfter']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'situationTagsJson': serializer.toJson<String>(situationTagsJson),
      'situationNote': serializer.toJson<String?>(situationNote),
      'negativeTemplateId': serializer.toJson<String>(negativeTemplateId),
      'negativeText': serializer.toJson<String>(negativeText),
      'negativeConfidence': serializer.toJson<int?>(negativeConfidence),
      'negativeFrequency': serializer.toJson<String?>(negativeFrequency),
      'distortionsJson': serializer.toJson<String>(distortionsJson),
      'balancedTemplateId': serializer.toJson<String>(balancedTemplateId),
      'balancedText': serializer.toJson<String>(balancedText),
      'emotionBefore': serializer.toJson<int?>(emotionBefore),
      'emotionAfter': serializer.toJson<int?>(emotionAfter),
    };
  }

  Entry copyWith({
    int? id,
    DateTime? createdAt,
    String? situationTagsJson,
    Value<String?> situationNote = const Value.absent(),
    String? negativeTemplateId,
    String? negativeText,
    Value<int?> negativeConfidence = const Value.absent(),
    Value<String?> negativeFrequency = const Value.absent(),
    String? distortionsJson,
    String? balancedTemplateId,
    String? balancedText,
    Value<int?> emotionBefore = const Value.absent(),
    Value<int?> emotionAfter = const Value.absent(),
  }) => Entry(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    situationTagsJson: situationTagsJson ?? this.situationTagsJson,
    situationNote: situationNote.present
        ? situationNote.value
        : this.situationNote,
    negativeTemplateId: negativeTemplateId ?? this.negativeTemplateId,
    negativeText: negativeText ?? this.negativeText,
    negativeConfidence: negativeConfidence.present
        ? negativeConfidence.value
        : this.negativeConfidence,
    negativeFrequency: negativeFrequency.present
        ? negativeFrequency.value
        : this.negativeFrequency,
    distortionsJson: distortionsJson ?? this.distortionsJson,
    balancedTemplateId: balancedTemplateId ?? this.balancedTemplateId,
    balancedText: balancedText ?? this.balancedText,
    emotionBefore: emotionBefore.present
        ? emotionBefore.value
        : this.emotionBefore,
    emotionAfter: emotionAfter.present ? emotionAfter.value : this.emotionAfter,
  );
  Entry copyWithCompanion(EntriesCompanion data) {
    return Entry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      situationTagsJson: data.situationTagsJson.present
          ? data.situationTagsJson.value
          : this.situationTagsJson,
      situationNote: data.situationNote.present
          ? data.situationNote.value
          : this.situationNote,
      negativeTemplateId: data.negativeTemplateId.present
          ? data.negativeTemplateId.value
          : this.negativeTemplateId,
      negativeText: data.negativeText.present
          ? data.negativeText.value
          : this.negativeText,
      negativeConfidence: data.negativeConfidence.present
          ? data.negativeConfidence.value
          : this.negativeConfidence,
      negativeFrequency: data.negativeFrequency.present
          ? data.negativeFrequency.value
          : this.negativeFrequency,
      distortionsJson: data.distortionsJson.present
          ? data.distortionsJson.value
          : this.distortionsJson,
      balancedTemplateId: data.balancedTemplateId.present
          ? data.balancedTemplateId.value
          : this.balancedTemplateId,
      balancedText: data.balancedText.present
          ? data.balancedText.value
          : this.balancedText,
      emotionBefore: data.emotionBefore.present
          ? data.emotionBefore.value
          : this.emotionBefore,
      emotionAfter: data.emotionAfter.present
          ? data.emotionAfter.value
          : this.emotionAfter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Entry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('situationTagsJson: $situationTagsJson, ')
          ..write('situationNote: $situationNote, ')
          ..write('negativeTemplateId: $negativeTemplateId, ')
          ..write('negativeText: $negativeText, ')
          ..write('negativeConfidence: $negativeConfidence, ')
          ..write('negativeFrequency: $negativeFrequency, ')
          ..write('distortionsJson: $distortionsJson, ')
          ..write('balancedTemplateId: $balancedTemplateId, ')
          ..write('balancedText: $balancedText, ')
          ..write('emotionBefore: $emotionBefore, ')
          ..write('emotionAfter: $emotionAfter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    situationTagsJson,
    situationNote,
    negativeTemplateId,
    negativeText,
    negativeConfidence,
    negativeFrequency,
    distortionsJson,
    balancedTemplateId,
    balancedText,
    emotionBefore,
    emotionAfter,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Entry &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.situationTagsJson == this.situationTagsJson &&
          other.situationNote == this.situationNote &&
          other.negativeTemplateId == this.negativeTemplateId &&
          other.negativeText == this.negativeText &&
          other.negativeConfidence == this.negativeConfidence &&
          other.negativeFrequency == this.negativeFrequency &&
          other.distortionsJson == this.distortionsJson &&
          other.balancedTemplateId == this.balancedTemplateId &&
          other.balancedText == this.balancedText &&
          other.emotionBefore == this.emotionBefore &&
          other.emotionAfter == this.emotionAfter);
}

class EntriesCompanion extends UpdateCompanion<Entry> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<String> situationTagsJson;
  final Value<String?> situationNote;
  final Value<String> negativeTemplateId;
  final Value<String> negativeText;
  final Value<int?> negativeConfidence;
  final Value<String?> negativeFrequency;
  final Value<String> distortionsJson;
  final Value<String> balancedTemplateId;
  final Value<String> balancedText;
  final Value<int?> emotionBefore;
  final Value<int?> emotionAfter;
  const EntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.situationTagsJson = const Value.absent(),
    this.situationNote = const Value.absent(),
    this.negativeTemplateId = const Value.absent(),
    this.negativeText = const Value.absent(),
    this.negativeConfidence = const Value.absent(),
    this.negativeFrequency = const Value.absent(),
    this.distortionsJson = const Value.absent(),
    this.balancedTemplateId = const Value.absent(),
    this.balancedText = const Value.absent(),
    this.emotionBefore = const Value.absent(),
    this.emotionAfter = const Value.absent(),
  });
  EntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
    required String situationTagsJson,
    this.situationNote = const Value.absent(),
    required String negativeTemplateId,
    required String negativeText,
    this.negativeConfidence = const Value.absent(),
    this.negativeFrequency = const Value.absent(),
    required String distortionsJson,
    required String balancedTemplateId,
    required String balancedText,
    this.emotionBefore = const Value.absent(),
    this.emotionAfter = const Value.absent(),
  }) : createdAt = Value(createdAt),
       situationTagsJson = Value(situationTagsJson),
       negativeTemplateId = Value(negativeTemplateId),
       negativeText = Value(negativeText),
       distortionsJson = Value(distortionsJson),
       balancedTemplateId = Value(balancedTemplateId),
       balancedText = Value(balancedText);
  static Insertable<Entry> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? situationTagsJson,
    Expression<String>? situationNote,
    Expression<String>? negativeTemplateId,
    Expression<String>? negativeText,
    Expression<int>? negativeConfidence,
    Expression<String>? negativeFrequency,
    Expression<String>? distortionsJson,
    Expression<String>? balancedTemplateId,
    Expression<String>? balancedText,
    Expression<int>? emotionBefore,
    Expression<int>? emotionAfter,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (situationTagsJson != null) 'situation_tags_json': situationTagsJson,
      if (situationNote != null) 'situation_note': situationNote,
      if (negativeTemplateId != null)
        'negative_template_id': negativeTemplateId,
      if (negativeText != null) 'negative_text': negativeText,
      if (negativeConfidence != null) 'negative_confidence': negativeConfidence,
      if (negativeFrequency != null) 'negative_frequency': negativeFrequency,
      if (distortionsJson != null) 'distortions_json': distortionsJson,
      if (balancedTemplateId != null)
        'balanced_template_id': balancedTemplateId,
      if (balancedText != null) 'balanced_text': balancedText,
      if (emotionBefore != null) 'emotion_before': emotionBefore,
      if (emotionAfter != null) 'emotion_after': emotionAfter,
    });
  }

  EntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<String>? situationTagsJson,
    Value<String?>? situationNote,
    Value<String>? negativeTemplateId,
    Value<String>? negativeText,
    Value<int?>? negativeConfidence,
    Value<String?>? negativeFrequency,
    Value<String>? distortionsJson,
    Value<String>? balancedTemplateId,
    Value<String>? balancedText,
    Value<int?>? emotionBefore,
    Value<int?>? emotionAfter,
  }) {
    return EntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      situationTagsJson: situationTagsJson ?? this.situationTagsJson,
      situationNote: situationNote ?? this.situationNote,
      negativeTemplateId: negativeTemplateId ?? this.negativeTemplateId,
      negativeText: negativeText ?? this.negativeText,
      negativeConfidence: negativeConfidence ?? this.negativeConfidence,
      negativeFrequency: negativeFrequency ?? this.negativeFrequency,
      distortionsJson: distortionsJson ?? this.distortionsJson,
      balancedTemplateId: balancedTemplateId ?? this.balancedTemplateId,
      balancedText: balancedText ?? this.balancedText,
      emotionBefore: emotionBefore ?? this.emotionBefore,
      emotionAfter: emotionAfter ?? this.emotionAfter,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (situationTagsJson.present) {
      map['situation_tags_json'] = Variable<String>(situationTagsJson.value);
    }
    if (situationNote.present) {
      map['situation_note'] = Variable<String>(situationNote.value);
    }
    if (negativeTemplateId.present) {
      map['negative_template_id'] = Variable<String>(negativeTemplateId.value);
    }
    if (negativeText.present) {
      map['negative_text'] = Variable<String>(negativeText.value);
    }
    if (negativeConfidence.present) {
      map['negative_confidence'] = Variable<int>(negativeConfidence.value);
    }
    if (negativeFrequency.present) {
      map['negative_frequency'] = Variable<String>(negativeFrequency.value);
    }
    if (distortionsJson.present) {
      map['distortions_json'] = Variable<String>(distortionsJson.value);
    }
    if (balancedTemplateId.present) {
      map['balanced_template_id'] = Variable<String>(balancedTemplateId.value);
    }
    if (balancedText.present) {
      map['balanced_text'] = Variable<String>(balancedText.value);
    }
    if (emotionBefore.present) {
      map['emotion_before'] = Variable<int>(emotionBefore.value);
    }
    if (emotionAfter.present) {
      map['emotion_after'] = Variable<int>(emotionAfter.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('situationTagsJson: $situationTagsJson, ')
          ..write('situationNote: $situationNote, ')
          ..write('negativeTemplateId: $negativeTemplateId, ')
          ..write('negativeText: $negativeText, ')
          ..write('negativeConfidence: $negativeConfidence, ')
          ..write('negativeFrequency: $negativeFrequency, ')
          ..write('distortionsJson: $distortionsJson, ')
          ..write('balancedTemplateId: $balancedTemplateId, ')
          ..write('balancedText: $balancedText, ')
          ..write('emotionBefore: $emotionBefore, ')
          ..write('emotionAfter: $emotionAfter')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EntriesTable entries = $EntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [entries];
}

typedef $$EntriesTableCreateCompanionBuilder =
    EntriesCompanion Function({
      Value<int> id,
      required DateTime createdAt,
      required String situationTagsJson,
      Value<String?> situationNote,
      required String negativeTemplateId,
      required String negativeText,
      Value<int?> negativeConfidence,
      Value<String?> negativeFrequency,
      required String distortionsJson,
      required String balancedTemplateId,
      required String balancedText,
      Value<int?> emotionBefore,
      Value<int?> emotionAfter,
    });
typedef $$EntriesTableUpdateCompanionBuilder =
    EntriesCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<String> situationTagsJson,
      Value<String?> situationNote,
      Value<String> negativeTemplateId,
      Value<String> negativeText,
      Value<int?> negativeConfidence,
      Value<String?> negativeFrequency,
      Value<String> distortionsJson,
      Value<String> balancedTemplateId,
      Value<String> balancedText,
      Value<int?> emotionBefore,
      Value<int?> emotionAfter,
    });

class $$EntriesTableFilterComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get situationTagsJson => $composableBuilder(
    column: $table.situationTagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get situationNote => $composableBuilder(
    column: $table.situationNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get negativeTemplateId => $composableBuilder(
    column: $table.negativeTemplateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get negativeText => $composableBuilder(
    column: $table.negativeText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get negativeConfidence => $composableBuilder(
    column: $table.negativeConfidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get negativeFrequency => $composableBuilder(
    column: $table.negativeFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get distortionsJson => $composableBuilder(
    column: $table.distortionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get balancedTemplateId => $composableBuilder(
    column: $table.balancedTemplateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get balancedText => $composableBuilder(
    column: $table.balancedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get emotionBefore => $composableBuilder(
    column: $table.emotionBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get emotionAfter => $composableBuilder(
    column: $table.emotionAfter,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get situationTagsJson => $composableBuilder(
    column: $table.situationTagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get situationNote => $composableBuilder(
    column: $table.situationNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get negativeTemplateId => $composableBuilder(
    column: $table.negativeTemplateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get negativeText => $composableBuilder(
    column: $table.negativeText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get negativeConfidence => $composableBuilder(
    column: $table.negativeConfidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get negativeFrequency => $composableBuilder(
    column: $table.negativeFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get distortionsJson => $composableBuilder(
    column: $table.distortionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get balancedTemplateId => $composableBuilder(
    column: $table.balancedTemplateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get balancedText => $composableBuilder(
    column: $table.balancedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get emotionBefore => $composableBuilder(
    column: $table.emotionBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get emotionAfter => $composableBuilder(
    column: $table.emotionAfter,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get situationTagsJson => $composableBuilder(
    column: $table.situationTagsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get situationNote => $composableBuilder(
    column: $table.situationNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get negativeTemplateId => $composableBuilder(
    column: $table.negativeTemplateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get negativeText => $composableBuilder(
    column: $table.negativeText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get negativeConfidence => $composableBuilder(
    column: $table.negativeConfidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get negativeFrequency => $composableBuilder(
    column: $table.negativeFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get distortionsJson => $composableBuilder(
    column: $table.distortionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get balancedTemplateId => $composableBuilder(
    column: $table.balancedTemplateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get balancedText => $composableBuilder(
    column: $table.balancedText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get emotionBefore => $composableBuilder(
    column: $table.emotionBefore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get emotionAfter => $composableBuilder(
    column: $table.emotionAfter,
    builder: (column) => column,
  );
}

class $$EntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntriesTable,
          Entry,
          $$EntriesTableFilterComposer,
          $$EntriesTableOrderingComposer,
          $$EntriesTableAnnotationComposer,
          $$EntriesTableCreateCompanionBuilder,
          $$EntriesTableUpdateCompanionBuilder,
          (Entry, BaseReferences<_$AppDatabase, $EntriesTable, Entry>),
          Entry,
          PrefetchHooks Function()
        > {
  $$EntriesTableTableManager(_$AppDatabase db, $EntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> situationTagsJson = const Value.absent(),
                Value<String?> situationNote = const Value.absent(),
                Value<String> negativeTemplateId = const Value.absent(),
                Value<String> negativeText = const Value.absent(),
                Value<int?> negativeConfidence = const Value.absent(),
                Value<String?> negativeFrequency = const Value.absent(),
                Value<String> distortionsJson = const Value.absent(),
                Value<String> balancedTemplateId = const Value.absent(),
                Value<String> balancedText = const Value.absent(),
                Value<int?> emotionBefore = const Value.absent(),
                Value<int?> emotionAfter = const Value.absent(),
              }) => EntriesCompanion(
                id: id,
                createdAt: createdAt,
                situationTagsJson: situationTagsJson,
                situationNote: situationNote,
                negativeTemplateId: negativeTemplateId,
                negativeText: negativeText,
                negativeConfidence: negativeConfidence,
                negativeFrequency: negativeFrequency,
                distortionsJson: distortionsJson,
                balancedTemplateId: balancedTemplateId,
                balancedText: balancedText,
                emotionBefore: emotionBefore,
                emotionAfter: emotionAfter,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime createdAt,
                required String situationTagsJson,
                Value<String?> situationNote = const Value.absent(),
                required String negativeTemplateId,
                required String negativeText,
                Value<int?> negativeConfidence = const Value.absent(),
                Value<String?> negativeFrequency = const Value.absent(),
                required String distortionsJson,
                required String balancedTemplateId,
                required String balancedText,
                Value<int?> emotionBefore = const Value.absent(),
                Value<int?> emotionAfter = const Value.absent(),
              }) => EntriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                situationTagsJson: situationTagsJson,
                situationNote: situationNote,
                negativeTemplateId: negativeTemplateId,
                negativeText: negativeText,
                negativeConfidence: negativeConfidence,
                negativeFrequency: negativeFrequency,
                distortionsJson: distortionsJson,
                balancedTemplateId: balancedTemplateId,
                balancedText: balancedText,
                emotionBefore: emotionBefore,
                emotionAfter: emotionAfter,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntriesTable,
      Entry,
      $$EntriesTableFilterComposer,
      $$EntriesTableOrderingComposer,
      $$EntriesTableAnnotationComposer,
      $$EntriesTableCreateCompanionBuilder,
      $$EntriesTableUpdateCompanionBuilder,
      (Entry, BaseReferences<_$AppDatabase, $EntriesTable, Entry>),
      Entry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EntriesTableTableManager get entries =>
      $$EntriesTableTableManager(_db, _db.entries);
}
