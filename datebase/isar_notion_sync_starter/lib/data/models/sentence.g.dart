// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentence.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSentenceCollection on Isar {
  IsarCollection<Sentence> get sentences => this.collection();
}

const SentenceSchema = CollectionSchema(
  name: r'Sentence',
  id: -4239196544648232134,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deletedAt': PropertySchema(
      id: 1,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'externalKey': PropertySchema(
      id: 2,
      name: r'externalKey',
      type: IsarType.string,
    ),
    r'familiarState': PropertySchema(
      id: 3,
      name: r'familiarState',
      type: IsarType.string,
      enumMap: _SentencefamiliarStateEnumValueMap,
    ),
    r'notionPageId': PropertySchema(
      id: 4,
      name: r'notionPageId',
      type: IsarType.string,
    ),
    r'text': PropertySchema(
      id: 5,
      name: r'text',
      type: IsarType.string,
    ),
    r'updatedAtLocal': PropertySchema(
      id: 6,
      name: r'updatedAtLocal',
      type: IsarType.dateTime,
    ),
    r'updatedAtRemote': PropertySchema(
      id: 7,
      name: r'updatedAtRemote',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _sentenceEstimateSize,
  serialize: _sentenceSerialize,
  deserialize: _sentenceDeserialize,
  deserializeProp: _sentenceDeserializeProp,
  idName: r'id',
  indexes: {
    r'notionPageId': IndexSchema(
      id: -8832551690891678375,
      name: r'notionPageId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'notionPageId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'externalKey': IndexSchema(
      id: 4573241076244886543,
      name: r'externalKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'externalKey',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'text': IndexSchema(
      id: 5145922347574273553,
      name: r'text',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'text',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'updatedAtLocal': IndexSchema(
      id: -5150154145654961119,
      name: r'updatedAtLocal',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAtLocal',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _sentenceGetId,
  getLinks: _sentenceGetLinks,
  attach: _sentenceAttach,
  version: '3.1.0+1',
);

int _sentenceEstimateSize(
  Sentence object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.externalKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.familiarState.name.length * 3;
  {
    final value = object.notionPageId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.text.length * 3;
  return bytesCount;
}

void _sentenceSerialize(
  Sentence object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDateTime(offsets[1], object.deletedAt);
  writer.writeString(offsets[2], object.externalKey);
  writer.writeString(offsets[3], object.familiarState.name);
  writer.writeString(offsets[4], object.notionPageId);
  writer.writeString(offsets[5], object.text);
  writer.writeDateTime(offsets[6], object.updatedAtLocal);
  writer.writeDateTime(offsets[7], object.updatedAtRemote);
}

Sentence _sentenceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Sentence();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.deletedAt = reader.readDateTimeOrNull(offsets[1]);
  object.externalKey = reader.readStringOrNull(offsets[2]);
  object.familiarState =
      _SentencefamiliarStateValueEnumMap[reader.readStringOrNull(offsets[3])] ??
          FamiliarState.familiar;
  object.id = id;
  object.notionPageId = reader.readStringOrNull(offsets[4]);
  object.text = reader.readString(offsets[5]);
  object.updatedAtLocal = reader.readDateTime(offsets[6]);
  object.updatedAtRemote = reader.readDateTimeOrNull(offsets[7]);
  return object;
}

P _sentenceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (_SentencefamiliarStateValueEnumMap[
              reader.readStringOrNull(offset)] ??
          FamiliarState.familiar) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SentencefamiliarStateEnumValueMap = {
  r'familiar': r'familiar',
  r'unfamiliar': r'unfamiliar',
  r'neutral': r'neutral',
};
const _SentencefamiliarStateValueEnumMap = {
  r'familiar': FamiliarState.familiar,
  r'unfamiliar': FamiliarState.unfamiliar,
  r'neutral': FamiliarState.neutral,
};

Id _sentenceGetId(Sentence object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sentenceGetLinks(Sentence object) {
  return [];
}

void _sentenceAttach(IsarCollection<dynamic> col, Id id, Sentence object) {
  object.id = id;
}

extension SentenceByIndex on IsarCollection<Sentence> {
  Future<Sentence?> getByNotionPageId(String? notionPageId) {
    return getByIndex(r'notionPageId', [notionPageId]);
  }

  Sentence? getByNotionPageIdSync(String? notionPageId) {
    return getByIndexSync(r'notionPageId', [notionPageId]);
  }

  Future<bool> deleteByNotionPageId(String? notionPageId) {
    return deleteByIndex(r'notionPageId', [notionPageId]);
  }

  bool deleteByNotionPageIdSync(String? notionPageId) {
    return deleteByIndexSync(r'notionPageId', [notionPageId]);
  }

  Future<List<Sentence?>> getAllByNotionPageId(
      List<String?> notionPageIdValues) {
    final values = notionPageIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'notionPageId', values);
  }

  List<Sentence?> getAllByNotionPageIdSync(List<String?> notionPageIdValues) {
    final values = notionPageIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'notionPageId', values);
  }

  Future<int> deleteAllByNotionPageId(List<String?> notionPageIdValues) {
    final values = notionPageIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'notionPageId', values);
  }

  int deleteAllByNotionPageIdSync(List<String?> notionPageIdValues) {
    final values = notionPageIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'notionPageId', values);
  }

  Future<Id> putByNotionPageId(Sentence object) {
    return putByIndex(r'notionPageId', object);
  }

  Id putByNotionPageIdSync(Sentence object, {bool saveLinks = true}) {
    return putByIndexSync(r'notionPageId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByNotionPageId(List<Sentence> objects) {
    return putAllByIndex(r'notionPageId', objects);
  }

  List<Id> putAllByNotionPageIdSync(List<Sentence> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'notionPageId', objects, saveLinks: saveLinks);
  }

  Future<Sentence?> getByExternalKey(String? externalKey) {
    return getByIndex(r'externalKey', [externalKey]);
  }

  Sentence? getByExternalKeySync(String? externalKey) {
    return getByIndexSync(r'externalKey', [externalKey]);
  }

  Future<bool> deleteByExternalKey(String? externalKey) {
    return deleteByIndex(r'externalKey', [externalKey]);
  }

  bool deleteByExternalKeySync(String? externalKey) {
    return deleteByIndexSync(r'externalKey', [externalKey]);
  }

  Future<List<Sentence?>> getAllByExternalKey(List<String?> externalKeyValues) {
    final values = externalKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'externalKey', values);
  }

  List<Sentence?> getAllByExternalKeySync(List<String?> externalKeyValues) {
    final values = externalKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'externalKey', values);
  }

  Future<int> deleteAllByExternalKey(List<String?> externalKeyValues) {
    final values = externalKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'externalKey', values);
  }

  int deleteAllByExternalKeySync(List<String?> externalKeyValues) {
    final values = externalKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'externalKey', values);
  }

  Future<Id> putByExternalKey(Sentence object) {
    return putByIndex(r'externalKey', object);
  }

  Id putByExternalKeySync(Sentence object, {bool saveLinks = true}) {
    return putByIndexSync(r'externalKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByExternalKey(List<Sentence> objects) {
    return putAllByIndex(r'externalKey', objects);
  }

  List<Id> putAllByExternalKeySync(List<Sentence> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'externalKey', objects, saveLinks: saveLinks);
  }
}

extension SentenceQueryWhereSort on QueryBuilder<Sentence, Sentence, QWhere> {
  QueryBuilder<Sentence, Sentence, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhere> anyUpdatedAtLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAtLocal'),
      );
    });
  }
}

extension SentenceQueryWhere on QueryBuilder<Sentence, Sentence, QWhereClause> {
  QueryBuilder<Sentence, Sentence, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> notionPageIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'notionPageId',
        value: [null],
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> notionPageIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'notionPageId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> notionPageIdEqualTo(
      String? notionPageId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'notionPageId',
        value: [notionPageId],
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> notionPageIdNotEqualTo(
      String? notionPageId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'notionPageId',
              lower: [],
              upper: [notionPageId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'notionPageId',
              lower: [notionPageId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'notionPageId',
              lower: [notionPageId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'notionPageId',
              lower: [],
              upper: [notionPageId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> externalKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'externalKey',
        value: [null],
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> externalKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'externalKey',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> externalKeyEqualTo(
      String? externalKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'externalKey',
        value: [externalKey],
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> externalKeyNotEqualTo(
      String? externalKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'externalKey',
              lower: [],
              upper: [externalKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'externalKey',
              lower: [externalKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'externalKey',
              lower: [externalKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'externalKey',
              lower: [],
              upper: [externalKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> textEqualTo(String text) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'text',
        value: [text],
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> textNotEqualTo(
      String text) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'text',
              lower: [],
              upper: [text],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'text',
              lower: [text],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'text',
              lower: [text],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'text',
              lower: [],
              upper: [text],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> updatedAtLocalEqualTo(
      DateTime updatedAtLocal) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAtLocal',
        value: [updatedAtLocal],
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> updatedAtLocalNotEqualTo(
      DateTime updatedAtLocal) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAtLocal',
              lower: [],
              upper: [updatedAtLocal],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAtLocal',
              lower: [updatedAtLocal],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAtLocal',
              lower: [updatedAtLocal],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAtLocal',
              lower: [],
              upper: [updatedAtLocal],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> updatedAtLocalGreaterThan(
    DateTime updatedAtLocal, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAtLocal',
        lower: [updatedAtLocal],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> updatedAtLocalLessThan(
    DateTime updatedAtLocal, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAtLocal',
        lower: [],
        upper: [updatedAtLocal],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterWhereClause> updatedAtLocalBetween(
    DateTime lowerUpdatedAtLocal,
    DateTime upperUpdatedAtLocal, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAtLocal',
        lower: [lowerUpdatedAtLocal],
        includeLower: includeLower,
        upper: [upperUpdatedAtLocal],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SentenceQueryFilter
    on QueryBuilder<Sentence, Sentence, QFilterCondition> {
  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> deletedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> deletedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> deletedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> deletedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deletedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> externalKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'externalKey',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      externalKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'externalKey',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> externalKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      externalKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'externalKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> externalKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'externalKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> externalKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'externalKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> externalKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'externalKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> externalKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'externalKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> externalKeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'externalKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> externalKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'externalKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> externalKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalKey',
        value: '',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      externalKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'externalKey',
        value: '',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> familiarStateEqualTo(
    FamiliarState value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'familiarState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      familiarStateGreaterThan(
    FamiliarState value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'familiarState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> familiarStateLessThan(
    FamiliarState value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'familiarState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> familiarStateBetween(
    FamiliarState lower,
    FamiliarState upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'familiarState',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      familiarStateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'familiarState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> familiarStateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'familiarState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> familiarStateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'familiarState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> familiarStateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'familiarState',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      familiarStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'familiarState',
        value: '',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      familiarStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'familiarState',
        value: '',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> notionPageIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notionPageId',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      notionPageIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notionPageId',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> notionPageIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notionPageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      notionPageIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notionPageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> notionPageIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notionPageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> notionPageIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notionPageId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      notionPageIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notionPageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> notionPageIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notionPageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> notionPageIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notionPageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> notionPageIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notionPageId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      notionPageIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notionPageId',
        value: '',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      notionPageIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notionPageId',
        value: '',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> textContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> textMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> updatedAtLocalEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAtLocal',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      updatedAtLocalGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAtLocal',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      updatedAtLocalLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAtLocal',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition> updatedAtLocalBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAtLocal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      updatedAtRemoteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAtRemote',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      updatedAtRemoteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAtRemote',
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      updatedAtRemoteEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAtRemote',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      updatedAtRemoteGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAtRemote',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      updatedAtRemoteLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAtRemote',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterFilterCondition>
      updatedAtRemoteBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAtRemote',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SentenceQueryObject
    on QueryBuilder<Sentence, Sentence, QFilterCondition> {}

extension SentenceQueryLinks
    on QueryBuilder<Sentence, Sentence, QFilterCondition> {}

extension SentenceQuerySortBy on QueryBuilder<Sentence, Sentence, QSortBy> {
  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByExternalKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalKey', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByExternalKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalKey', Sort.desc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByFamiliarState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familiarState', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByFamiliarStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familiarState', Sort.desc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByNotionPageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notionPageId', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByNotionPageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notionPageId', Sort.desc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByUpdatedAtLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtLocal', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByUpdatedAtLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtLocal', Sort.desc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByUpdatedAtRemote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtRemote', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> sortByUpdatedAtRemoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtRemote', Sort.desc);
    });
  }
}

extension SentenceQuerySortThenBy
    on QueryBuilder<Sentence, Sentence, QSortThenBy> {
  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByExternalKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalKey', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByExternalKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalKey', Sort.desc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByFamiliarState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familiarState', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByFamiliarStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familiarState', Sort.desc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByNotionPageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notionPageId', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByNotionPageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notionPageId', Sort.desc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByUpdatedAtLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtLocal', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByUpdatedAtLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtLocal', Sort.desc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByUpdatedAtRemote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtRemote', Sort.asc);
    });
  }

  QueryBuilder<Sentence, Sentence, QAfterSortBy> thenByUpdatedAtRemoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtRemote', Sort.desc);
    });
  }
}

extension SentenceQueryWhereDistinct
    on QueryBuilder<Sentence, Sentence, QDistinct> {
  QueryBuilder<Sentence, Sentence, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Sentence, Sentence, QDistinct> distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<Sentence, Sentence, QDistinct> distinctByExternalKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'externalKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sentence, Sentence, QDistinct> distinctByFamiliarState(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'familiarState',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sentence, Sentence, QDistinct> distinctByNotionPageId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notionPageId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sentence, Sentence, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sentence, Sentence, QDistinct> distinctByUpdatedAtLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAtLocal');
    });
  }

  QueryBuilder<Sentence, Sentence, QDistinct> distinctByUpdatedAtRemote() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAtRemote');
    });
  }
}

extension SentenceQueryProperty
    on QueryBuilder<Sentence, Sentence, QQueryProperty> {
  QueryBuilder<Sentence, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Sentence, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Sentence, DateTime?, QQueryOperations> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<Sentence, String?, QQueryOperations> externalKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'externalKey');
    });
  }

  QueryBuilder<Sentence, FamiliarState, QQueryOperations>
      familiarStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'familiarState');
    });
  }

  QueryBuilder<Sentence, String?, QQueryOperations> notionPageIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notionPageId');
    });
  }

  QueryBuilder<Sentence, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }

  QueryBuilder<Sentence, DateTime, QQueryOperations> updatedAtLocalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAtLocal');
    });
  }

  QueryBuilder<Sentence, DateTime?, QQueryOperations>
      updatedAtRemoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAtRemote');
    });
  }
}
