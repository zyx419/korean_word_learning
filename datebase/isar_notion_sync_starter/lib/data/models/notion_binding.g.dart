// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notion_binding.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNotionDatabaseBindingCollection on Isar {
  IsarCollection<NotionDatabaseBinding> get notionDatabaseBindings =>
      this.collection();
}

const NotionDatabaseBindingSchema = CollectionSchema(
  name: r'NotionDatabaseBinding',
  id: 2042162149747467156,
  properties: {
    r'boundAt': PropertySchema(
      id: 0,
      name: r'boundAt',
      type: IsarType.dateTime,
    ),
    r'databaseId': PropertySchema(
      id: 1,
      name: r'databaseId',
      type: IsarType.string,
    ),
    r'databaseName': PropertySchema(
      id: 2,
      name: r'databaseName',
      type: IsarType.string,
    ),
    r'rawUrl': PropertySchema(
      id: 3,
      name: r'rawUrl',
      type: IsarType.string,
    ),
    r'workspace': PropertySchema(
      id: 4,
      name: r'workspace',
      type: IsarType.string,
    )
  },
  estimateSize: _notionDatabaseBindingEstimateSize,
  serialize: _notionDatabaseBindingSerialize,
  deserialize: _notionDatabaseBindingDeserialize,
  deserializeProp: _notionDatabaseBindingDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _notionDatabaseBindingGetId,
  getLinks: _notionDatabaseBindingGetLinks,
  attach: _notionDatabaseBindingAttach,
  version: '3.1.0+1',
);

int _notionDatabaseBindingEstimateSize(
  NotionDatabaseBinding object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.databaseId.length * 3;
  bytesCount += 3 + object.databaseName.length * 3;
  bytesCount += 3 + object.rawUrl.length * 3;
  {
    final value = object.workspace;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _notionDatabaseBindingSerialize(
  NotionDatabaseBinding object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.boundAt);
  writer.writeString(offsets[1], object.databaseId);
  writer.writeString(offsets[2], object.databaseName);
  writer.writeString(offsets[3], object.rawUrl);
  writer.writeString(offsets[4], object.workspace);
}

NotionDatabaseBinding _notionDatabaseBindingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NotionDatabaseBinding();
  object.boundAt = reader.readDateTime(offsets[0]);
  object.databaseId = reader.readString(offsets[1]);
  object.databaseName = reader.readString(offsets[2]);
  object.id = id;
  object.rawUrl = reader.readString(offsets[3]);
  object.workspace = reader.readStringOrNull(offsets[4]);
  return object;
}

P _notionDatabaseBindingDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _notionDatabaseBindingGetId(NotionDatabaseBinding object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _notionDatabaseBindingGetLinks(
    NotionDatabaseBinding object) {
  return [];
}

void _notionDatabaseBindingAttach(
    IsarCollection<dynamic> col, Id id, NotionDatabaseBinding object) {
  object.id = id;
}

extension NotionDatabaseBindingQueryWhereSort
    on QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QWhere> {
  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NotionDatabaseBindingQueryWhere on QueryBuilder<NotionDatabaseBinding,
    NotionDatabaseBinding, QWhereClause> {
  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterWhereClause>
      idBetween(
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
}

extension NotionDatabaseBindingQueryFilter on QueryBuilder<
    NotionDatabaseBinding, NotionDatabaseBinding, QFilterCondition> {
  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> boundAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'boundAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> boundAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'boundAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> boundAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'boundAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> boundAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'boundAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'databaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'databaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'databaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'databaseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'databaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'databaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
          QAfterFilterCondition>
      databaseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'databaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
          QAfterFilterCondition>
      databaseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'databaseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'databaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'databaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'databaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'databaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'databaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'databaseName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'databaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'databaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
          QAfterFilterCondition>
      databaseNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'databaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
          QAfterFilterCondition>
      databaseNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'databaseName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'databaseName',
        value: '',
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> databaseNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'databaseName',
        value: '',
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> rawUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> rawUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> rawUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> rawUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> rawUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> rawUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
          QAfterFilterCondition>
      rawUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
          QAfterFilterCondition>
      rawUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> rawUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> rawUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> workspaceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'workspace',
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> workspaceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'workspace',
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> workspaceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workspace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> workspaceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workspace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> workspaceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workspace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> workspaceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workspace',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> workspaceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'workspace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> workspaceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'workspace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
          QAfterFilterCondition>
      workspaceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'workspace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
          QAfterFilterCondition>
      workspaceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'workspace',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> workspaceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workspace',
        value: '',
      ));
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding,
      QAfterFilterCondition> workspaceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workspace',
        value: '',
      ));
    });
  }
}

extension NotionDatabaseBindingQueryObject on QueryBuilder<
    NotionDatabaseBinding, NotionDatabaseBinding, QFilterCondition> {}

extension NotionDatabaseBindingQueryLinks on QueryBuilder<NotionDatabaseBinding,
    NotionDatabaseBinding, QFilterCondition> {}

extension NotionDatabaseBindingQuerySortBy
    on QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QSortBy> {
  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      sortByBoundAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boundAt', Sort.asc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      sortByBoundAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boundAt', Sort.desc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      sortByDatabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'databaseId', Sort.asc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      sortByDatabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'databaseId', Sort.desc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      sortByDatabaseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'databaseName', Sort.asc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      sortByDatabaseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'databaseName', Sort.desc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      sortByRawUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawUrl', Sort.asc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      sortByRawUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawUrl', Sort.desc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      sortByWorkspace() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspace', Sort.asc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      sortByWorkspaceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspace', Sort.desc);
    });
  }
}

extension NotionDatabaseBindingQuerySortThenBy
    on QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QSortThenBy> {
  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      thenByBoundAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boundAt', Sort.asc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      thenByBoundAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boundAt', Sort.desc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      thenByDatabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'databaseId', Sort.asc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      thenByDatabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'databaseId', Sort.desc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      thenByDatabaseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'databaseName', Sort.asc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      thenByDatabaseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'databaseName', Sort.desc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      thenByRawUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawUrl', Sort.asc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      thenByRawUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawUrl', Sort.desc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      thenByWorkspace() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspace', Sort.asc);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QAfterSortBy>
      thenByWorkspaceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspace', Sort.desc);
    });
  }
}

extension NotionDatabaseBindingQueryWhereDistinct
    on QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QDistinct> {
  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QDistinct>
      distinctByBoundAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'boundAt');
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QDistinct>
      distinctByDatabaseId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'databaseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QDistinct>
      distinctByDatabaseName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'databaseName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QDistinct>
      distinctByRawUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotionDatabaseBinding, NotionDatabaseBinding, QDistinct>
      distinctByWorkspace({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workspace', caseSensitive: caseSensitive);
    });
  }
}

extension NotionDatabaseBindingQueryProperty on QueryBuilder<
    NotionDatabaseBinding, NotionDatabaseBinding, QQueryProperty> {
  QueryBuilder<NotionDatabaseBinding, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NotionDatabaseBinding, DateTime, QQueryOperations>
      boundAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'boundAt');
    });
  }

  QueryBuilder<NotionDatabaseBinding, String, QQueryOperations>
      databaseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'databaseId');
    });
  }

  QueryBuilder<NotionDatabaseBinding, String, QQueryOperations>
      databaseNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'databaseName');
    });
  }

  QueryBuilder<NotionDatabaseBinding, String, QQueryOperations>
      rawUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawUrl');
    });
  }

  QueryBuilder<NotionDatabaseBinding, String?, QQueryOperations>
      workspaceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workspace');
    });
  }
}
