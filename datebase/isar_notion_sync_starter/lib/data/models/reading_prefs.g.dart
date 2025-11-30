// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_prefs.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReadingPrefsCollection on Isar {
  IsarCollection<ReadingPrefs> get readingPrefs => this.collection();
}

const ReadingPrefsSchema = CollectionSchema(
  name: r'ReadingPrefs',
  id: -1122318022444650671,
  properties: {
    r'externalKey': PropertySchema(
      id: 0,
      name: r'externalKey',
      type: IsarType.string,
    ),
    r'filterState': PropertySchema(
      id: 1,
      name: r'filterState',
      type: IsarType.string,
      enumMap: _ReadingPrefsfilterStateEnumValueMap,
    ),
    r'fontSize': PropertySchema(
      id: 2,
      name: r'fontSize',
      type: IsarType.long,
    ),
    r'lineHeight': PropertySchema(
      id: 3,
      name: r'lineHeight',
      type: IsarType.double,
    ),
    r'notionPageId': PropertySchema(
      id: 4,
      name: r'notionPageId',
      type: IsarType.string,
    ),
    r'paragraphSpacing': PropertySchema(
      id: 5,
      name: r'paragraphSpacing',
      type: IsarType.long,
    ),
    r'scrollOffsetAll': PropertySchema(
      id: 6,
      name: r'scrollOffsetAll',
      type: IsarType.double,
    ),
    r'scrollOffsetFamiliar': PropertySchema(
      id: 7,
      name: r'scrollOffsetFamiliar',
      type: IsarType.double,
    ),
    r'scrollOffsetNeutral': PropertySchema(
      id: 8,
      name: r'scrollOffsetNeutral',
      type: IsarType.double,
    ),
    r'scrollOffsetUnfamiliar': PropertySchema(
      id: 9,
      name: r'scrollOffsetUnfamiliar',
      type: IsarType.double,
    ),
    r'theme': PropertySchema(
      id: 10,
      name: r'theme',
      type: IsarType.string,
    ),
    r'updatedAtLocal': PropertySchema(
      id: 11,
      name: r'updatedAtLocal',
      type: IsarType.dateTime,
    ),
    r'updatedAtRemote': PropertySchema(
      id: 12,
      name: r'updatedAtRemote',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _readingPrefsEstimateSize,
  serialize: _readingPrefsSerialize,
  deserialize: _readingPrefsDeserialize,
  deserializeProp: _readingPrefsDeserializeProp,
  idName: r'id',
  indexes: {
    r'notionPageId': IndexSchema(
      id: -8832551690891678375,
      name: r'notionPageId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'notionPageId',
          type: IndexType.hash,
          caseSensitive: false,
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
  getId: _readingPrefsGetId,
  getLinks: _readingPrefsGetLinks,
  attach: _readingPrefsAttach,
  version: '3.1.0+1',
);

int _readingPrefsEstimateSize(
  ReadingPrefs object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.externalKey.length * 3;
  {
    final value = object.filterState;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.notionPageId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.theme.length * 3;
  return bytesCount;
}

void _readingPrefsSerialize(
  ReadingPrefs object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.externalKey);
  writer.writeString(offsets[1], object.filterState?.name);
  writer.writeLong(offsets[2], object.fontSize);
  writer.writeDouble(offsets[3], object.lineHeight);
  writer.writeString(offsets[4], object.notionPageId);
  writer.writeLong(offsets[5], object.paragraphSpacing);
  writer.writeDouble(offsets[6], object.scrollOffsetAll);
  writer.writeDouble(offsets[7], object.scrollOffsetFamiliar);
  writer.writeDouble(offsets[8], object.scrollOffsetNeutral);
  writer.writeDouble(offsets[9], object.scrollOffsetUnfamiliar);
  writer.writeString(offsets[10], object.theme);
  writer.writeDateTime(offsets[11], object.updatedAtLocal);
  writer.writeDateTime(offsets[12], object.updatedAtRemote);
}

ReadingPrefs _readingPrefsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReadingPrefs();
  object.externalKey = reader.readString(offsets[0]);
  object.filterState =
      _ReadingPrefsfilterStateValueEnumMap[reader.readStringOrNull(offsets[1])];
  object.fontSize = reader.readLong(offsets[2]);
  object.id = id;
  object.lineHeight = reader.readDouble(offsets[3]);
  object.notionPageId = reader.readStringOrNull(offsets[4]);
  object.paragraphSpacing = reader.readLong(offsets[5]);
  object.scrollOffsetAll = reader.readDouble(offsets[6]);
  object.scrollOffsetFamiliar = reader.readDouble(offsets[7]);
  object.scrollOffsetNeutral = reader.readDouble(offsets[8]);
  object.scrollOffsetUnfamiliar = reader.readDouble(offsets[9]);
  object.theme = reader.readString(offsets[10]);
  object.updatedAtLocal = reader.readDateTime(offsets[11]);
  object.updatedAtRemote = reader.readDateTimeOrNull(offsets[12]);
  return object;
}

P _readingPrefsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (_ReadingPrefsfilterStateValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ReadingPrefsfilterStateEnumValueMap = {
  r'familiar': r'familiar',
  r'unfamiliar': r'unfamiliar',
  r'neutral': r'neutral',
};
const _ReadingPrefsfilterStateValueEnumMap = {
  r'familiar': FamiliarState.familiar,
  r'unfamiliar': FamiliarState.unfamiliar,
  r'neutral': FamiliarState.neutral,
};

Id _readingPrefsGetId(ReadingPrefs object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _readingPrefsGetLinks(ReadingPrefs object) {
  return [];
}

void _readingPrefsAttach(
    IsarCollection<dynamic> col, Id id, ReadingPrefs object) {
  object.id = id;
}

extension ReadingPrefsByIndex on IsarCollection<ReadingPrefs> {
  Future<ReadingPrefs?> getByExternalKey(String externalKey) {
    return getByIndex(r'externalKey', [externalKey]);
  }

  ReadingPrefs? getByExternalKeySync(String externalKey) {
    return getByIndexSync(r'externalKey', [externalKey]);
  }

  Future<bool> deleteByExternalKey(String externalKey) {
    return deleteByIndex(r'externalKey', [externalKey]);
  }

  bool deleteByExternalKeySync(String externalKey) {
    return deleteByIndexSync(r'externalKey', [externalKey]);
  }

  Future<List<ReadingPrefs?>> getAllByExternalKey(
      List<String> externalKeyValues) {
    final values = externalKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'externalKey', values);
  }

  List<ReadingPrefs?> getAllByExternalKeySync(List<String> externalKeyValues) {
    final values = externalKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'externalKey', values);
  }

  Future<int> deleteAllByExternalKey(List<String> externalKeyValues) {
    final values = externalKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'externalKey', values);
  }

  int deleteAllByExternalKeySync(List<String> externalKeyValues) {
    final values = externalKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'externalKey', values);
  }

  Future<Id> putByExternalKey(ReadingPrefs object) {
    return putByIndex(r'externalKey', object);
  }

  Id putByExternalKeySync(ReadingPrefs object, {bool saveLinks = true}) {
    return putByIndexSync(r'externalKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByExternalKey(List<ReadingPrefs> objects) {
    return putAllByIndex(r'externalKey', objects);
  }

  List<Id> putAllByExternalKeySync(List<ReadingPrefs> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'externalKey', objects, saveLinks: saveLinks);
  }
}

extension ReadingPrefsQueryWhereSort
    on QueryBuilder<ReadingPrefs, ReadingPrefs, QWhere> {
  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhere> anyUpdatedAtLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAtLocal'),
      );
    });
  }
}

extension ReadingPrefsQueryWhere
    on QueryBuilder<ReadingPrefs, ReadingPrefs, QWhereClause> {
  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause> idBetween(
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause>
      notionPageIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'notionPageId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause>
      notionPageIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'notionPageId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause>
      notionPageIdEqualTo(String? notionPageId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'notionPageId',
        value: [notionPageId],
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause>
      notionPageIdNotEqualTo(String? notionPageId) {
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause>
      externalKeyEqualTo(String externalKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'externalKey',
        value: [externalKey],
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause>
      externalKeyNotEqualTo(String externalKey) {
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause>
      updatedAtLocalEqualTo(DateTime updatedAtLocal) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAtLocal',
        value: [updatedAtLocal],
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause>
      updatedAtLocalNotEqualTo(DateTime updatedAtLocal) {
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause>
      updatedAtLocalGreaterThan(
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause>
      updatedAtLocalLessThan(
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterWhereClause>
      updatedAtLocalBetween(
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

extension ReadingPrefsQueryFilter
    on QueryBuilder<ReadingPrefs, ReadingPrefs, QFilterCondition> {
  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      externalKeyEqualTo(
    String value, {
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      externalKeyGreaterThan(
    String value, {
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      externalKeyLessThan(
    String value, {
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      externalKeyBetween(
    String lower,
    String upper, {
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      externalKeyStartsWith(
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      externalKeyEndsWith(
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      externalKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'externalKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      externalKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'externalKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      externalKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalKey',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      externalKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'externalKey',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      filterStateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'filterState',
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      filterStateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'filterState',
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      filterStateEqualTo(
    FamiliarState? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filterState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      filterStateGreaterThan(
    FamiliarState? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filterState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      filterStateLessThan(
    FamiliarState? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filterState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      filterStateBetween(
    FamiliarState? lower,
    FamiliarState? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filterState',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      filterStateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'filterState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      filterStateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'filterState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      filterStateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filterState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      filterStateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filterState',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      filterStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filterState',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      filterStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filterState',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      fontSizeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontSize',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      fontSizeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fontSize',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      fontSizeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fontSize',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      fontSizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fontSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      lineHeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lineHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      lineHeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lineHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      lineHeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lineHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      lineHeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lineHeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      notionPageIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notionPageId',
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      notionPageIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notionPageId',
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      notionPageIdEqualTo(
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      notionPageIdLessThan(
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      notionPageIdBetween(
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      notionPageIdEndsWith(
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      notionPageIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notionPageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      notionPageIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notionPageId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      notionPageIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notionPageId',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      notionPageIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notionPageId',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      paragraphSpacingEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paragraphSpacing',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      paragraphSpacingGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paragraphSpacing',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      paragraphSpacingLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paragraphSpacing',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      paragraphSpacingBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paragraphSpacing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetAllEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scrollOffsetAll',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetAllGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scrollOffsetAll',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetAllLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scrollOffsetAll',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetAllBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scrollOffsetAll',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetFamiliarEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scrollOffsetFamiliar',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetFamiliarGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scrollOffsetFamiliar',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetFamiliarLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scrollOffsetFamiliar',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetFamiliarBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scrollOffsetFamiliar',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetNeutralEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scrollOffsetNeutral',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetNeutralGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scrollOffsetNeutral',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetNeutralLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scrollOffsetNeutral',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetNeutralBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scrollOffsetNeutral',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetUnfamiliarEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scrollOffsetUnfamiliar',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetUnfamiliarGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scrollOffsetUnfamiliar',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetUnfamiliarLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scrollOffsetUnfamiliar',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetUnfamiliarBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scrollOffsetUnfamiliar',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition> themeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      themeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition> themeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition> themeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'theme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      themeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition> themeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition> themeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition> themeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'theme',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      themeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      themeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'theme',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      updatedAtLocalEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAtLocal',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      updatedAtLocalBetween(
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      updatedAtRemoteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAtRemote',
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      updatedAtRemoteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAtRemote',
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      updatedAtRemoteEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAtRemote',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
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

extension ReadingPrefsQueryObject
    on QueryBuilder<ReadingPrefs, ReadingPrefs, QFilterCondition> {}

extension ReadingPrefsQueryLinks
    on QueryBuilder<ReadingPrefs, ReadingPrefs, QFilterCondition> {}

extension ReadingPrefsQuerySortBy
    on QueryBuilder<ReadingPrefs, ReadingPrefs, QSortBy> {
  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> sortByExternalKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalKey', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByExternalKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalKey', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> sortByFilterState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterState', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByFilterStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterState', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> sortByFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> sortByFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> sortByLineHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lineHeight', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByLineHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lineHeight', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> sortByNotionPageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notionPageId', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByNotionPageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notionPageId', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByParagraphSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paragraphSpacing', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByParagraphSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paragraphSpacing', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByScrollOffsetAll() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetAll', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByScrollOffsetAllDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetAll', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByScrollOffsetFamiliar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetFamiliar', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByScrollOffsetFamiliarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetFamiliar', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByScrollOffsetNeutral() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetNeutral', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByScrollOffsetNeutralDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetNeutral', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByScrollOffsetUnfamiliar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetUnfamiliar', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByScrollOffsetUnfamiliarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetUnfamiliar', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> sortByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> sortByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByUpdatedAtLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtLocal', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByUpdatedAtLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtLocal', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByUpdatedAtRemote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtRemote', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByUpdatedAtRemoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtRemote', Sort.desc);
    });
  }
}

extension ReadingPrefsQuerySortThenBy
    on QueryBuilder<ReadingPrefs, ReadingPrefs, QSortThenBy> {
  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> thenByExternalKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalKey', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByExternalKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalKey', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> thenByFilterState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterState', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByFilterStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterState', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> thenByFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> thenByFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> thenByLineHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lineHeight', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByLineHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lineHeight', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> thenByNotionPageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notionPageId', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByNotionPageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notionPageId', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByParagraphSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paragraphSpacing', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByParagraphSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paragraphSpacing', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByScrollOffsetAll() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetAll', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByScrollOffsetAllDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetAll', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByScrollOffsetFamiliar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetFamiliar', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByScrollOffsetFamiliarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetFamiliar', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByScrollOffsetNeutral() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetNeutral', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByScrollOffsetNeutralDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetNeutral', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByScrollOffsetUnfamiliar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetUnfamiliar', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByScrollOffsetUnfamiliarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffsetUnfamiliar', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> thenByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> thenByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByUpdatedAtLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtLocal', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByUpdatedAtLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtLocal', Sort.desc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByUpdatedAtRemote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtRemote', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByUpdatedAtRemoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtRemote', Sort.desc);
    });
  }
}

extension ReadingPrefsQueryWhereDistinct
    on QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct> {
  QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct> distinctByExternalKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'externalKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct> distinctByFilterState(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filterState', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct> distinctByFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fontSize');
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct> distinctByLineHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lineHeight');
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct> distinctByNotionPageId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notionPageId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct>
      distinctByParagraphSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paragraphSpacing');
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct>
      distinctByScrollOffsetAll() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scrollOffsetAll');
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct>
      distinctByScrollOffsetFamiliar() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scrollOffsetFamiliar');
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct>
      distinctByScrollOffsetNeutral() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scrollOffsetNeutral');
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct>
      distinctByScrollOffsetUnfamiliar() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scrollOffsetUnfamiliar');
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct> distinctByTheme(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'theme', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct>
      distinctByUpdatedAtLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAtLocal');
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct>
      distinctByUpdatedAtRemote() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAtRemote');
    });
  }
}

extension ReadingPrefsQueryProperty
    on QueryBuilder<ReadingPrefs, ReadingPrefs, QQueryProperty> {
  QueryBuilder<ReadingPrefs, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReadingPrefs, String, QQueryOperations> externalKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'externalKey');
    });
  }

  QueryBuilder<ReadingPrefs, FamiliarState?, QQueryOperations>
      filterStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filterState');
    });
  }

  QueryBuilder<ReadingPrefs, int, QQueryOperations> fontSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fontSize');
    });
  }

  QueryBuilder<ReadingPrefs, double, QQueryOperations> lineHeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lineHeight');
    });
  }

  QueryBuilder<ReadingPrefs, String?, QQueryOperations> notionPageIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notionPageId');
    });
  }

  QueryBuilder<ReadingPrefs, int, QQueryOperations> paragraphSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paragraphSpacing');
    });
  }

  QueryBuilder<ReadingPrefs, double, QQueryOperations>
      scrollOffsetAllProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scrollOffsetAll');
    });
  }

  QueryBuilder<ReadingPrefs, double, QQueryOperations>
      scrollOffsetFamiliarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scrollOffsetFamiliar');
    });
  }

  QueryBuilder<ReadingPrefs, double, QQueryOperations>
      scrollOffsetNeutralProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scrollOffsetNeutral');
    });
  }

  QueryBuilder<ReadingPrefs, double, QQueryOperations>
      scrollOffsetUnfamiliarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scrollOffsetUnfamiliar');
    });
  }

  QueryBuilder<ReadingPrefs, String, QQueryOperations> themeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'theme');
    });
  }

  QueryBuilder<ReadingPrefs, DateTime, QQueryOperations>
      updatedAtLocalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAtLocal');
    });
  }

  QueryBuilder<ReadingPrefs, DateTime?, QQueryOperations>
      updatedAtRemoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAtRemote');
    });
  }
}
