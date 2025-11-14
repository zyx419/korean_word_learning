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
    r'fontSize': PropertySchema(
      id: 0,
      name: r'fontSize',
      type: IsarType.long,
    ),
    r'lineHeight': PropertySchema(
      id: 1,
      name: r'lineHeight',
      type: IsarType.double,
    ),
    r'paragraphSpacing': PropertySchema(
      id: 2,
      name: r'paragraphSpacing',
      type: IsarType.long,
    ),
    r'scrollOffset': PropertySchema(
      id: 3,
      name: r'scrollOffset',
      type: IsarType.double,
    ),
    r'theme': PropertySchema(
      id: 4,
      name: r'theme',
      type: IsarType.string,
    ),
    r'updatedAtLocal': PropertySchema(
      id: 5,
      name: r'updatedAtLocal',
      type: IsarType.dateTime,
    ),
    r'updatedAtRemote': PropertySchema(
      id: 6,
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
  bytesCount += 3 + object.theme.length * 3;
  return bytesCount;
}

void _readingPrefsSerialize(
  ReadingPrefs object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.fontSize);
  writer.writeDouble(offsets[1], object.lineHeight);
  writer.writeLong(offsets[2], object.paragraphSpacing);
  writer.writeDouble(offsets[3], object.scrollOffset);
  writer.writeString(offsets[4], object.theme);
  writer.writeDateTime(offsets[5], object.updatedAtLocal);
  writer.writeDateTime(offsets[6], object.updatedAtRemote);
}

ReadingPrefs _readingPrefsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReadingPrefs();
  object.fontSize = reader.readLong(offsets[0]);
  object.id = id;
  object.lineHeight = reader.readDouble(offsets[1]);
  object.paragraphSpacing = reader.readLong(offsets[2]);
  object.scrollOffset = reader.readDouble(offsets[3]);
  object.theme = reader.readString(offsets[4]);
  object.updatedAtLocal = reader.readDateTime(offsets[5]);
  object.updatedAtRemote = reader.readDateTimeOrNull(offsets[6]);
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
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

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
      scrollOffsetEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scrollOffset',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scrollOffset',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scrollOffset',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterFilterCondition>
      scrollOffsetBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scrollOffset',
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> sortByScrollOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffset', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      sortByScrollOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffset', Sort.desc);
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy> thenByScrollOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffset', Sort.asc);
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QAfterSortBy>
      thenByScrollOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scrollOffset', Sort.desc);
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

  QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct>
      distinctByParagraphSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paragraphSpacing');
    });
  }

  QueryBuilder<ReadingPrefs, ReadingPrefs, QDistinct> distinctByScrollOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scrollOffset');
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

  QueryBuilder<ReadingPrefs, int, QQueryOperations> paragraphSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paragraphSpacing');
    });
  }

  QueryBuilder<ReadingPrefs, double, QQueryOperations> scrollOffsetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scrollOffset');
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
