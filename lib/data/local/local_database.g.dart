// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $CachedDealsTable extends CachedDeals
    with TableInfo<$CachedDealsTable, CachedDeal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedDealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalPriceMeta = const VerificationMeta(
    'originalPrice',
  );
  @override
  late final GeneratedColumn<double> originalPrice = GeneratedColumn<double>(
    'original_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dealPriceMeta = const VerificationMeta(
    'dealPrice',
  );
  @override
  late final GeneratedColumn<double> dealPrice = GeneratedColumn<double>(
    'deal_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeMeta = const VerificationMeta('store');
  @override
  late final GeneratedColumn<String> store = GeneratedColumn<String>(
    'store',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _upvotesMeta = const VerificationMeta(
    'upvotes',
  );
  @override
  late final GeneratedColumn<int> upvotes = GeneratedColumn<int>(
    'upvotes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _downvotesMeta = const VerificationMeta(
    'downvotes',
  );
  @override
  late final GeneratedColumn<int> downvotes = GeneratedColumn<int>(
    'downvotes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _postedAtMeta = const VerificationMeta(
    'postedAt',
  );
  @override
  late final GeneratedColumn<DateTime> postedAt = GeneratedColumn<DateTime>(
    'posted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isHotMeta = const VerificationMeta('isHot');
  @override
  late final GeneratedColumn<bool> isHot = GeneratedColumn<bool>(
    'is_hot',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_hot" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasFreeShippingMeta = const VerificationMeta(
    'hasFreeShipping',
  );
  @override
  late final GeneratedColumn<bool> hasFreeShipping = GeneratedColumn<bool>(
    'has_free_shipping',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_free_shipping" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    originalPrice,
    dealPrice,
    imageUrl,
    store,
    category,
    upvotes,
    downvotes,
    postedAt,
    isHot,
    hasFreeShipping,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_deals';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedDeal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('original_price')) {
      context.handle(
        _originalPriceMeta,
        originalPrice.isAcceptableOrUnknown(
          data['original_price']!,
          _originalPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalPriceMeta);
    }
    if (data.containsKey('deal_price')) {
      context.handle(
        _dealPriceMeta,
        dealPrice.isAcceptableOrUnknown(data['deal_price']!, _dealPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_dealPriceMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('store')) {
      context.handle(
        _storeMeta,
        store.isAcceptableOrUnknown(data['store']!, _storeMeta),
      );
    } else if (isInserting) {
      context.missing(_storeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('upvotes')) {
      context.handle(
        _upvotesMeta,
        upvotes.isAcceptableOrUnknown(data['upvotes']!, _upvotesMeta),
      );
    }
    if (data.containsKey('downvotes')) {
      context.handle(
        _downvotesMeta,
        downvotes.isAcceptableOrUnknown(data['downvotes']!, _downvotesMeta),
      );
    }
    if (data.containsKey('posted_at')) {
      context.handle(
        _postedAtMeta,
        postedAt.isAcceptableOrUnknown(data['posted_at']!, _postedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_postedAtMeta);
    }
    if (data.containsKey('is_hot')) {
      context.handle(
        _isHotMeta,
        isHot.isAcceptableOrUnknown(data['is_hot']!, _isHotMeta),
      );
    }
    if (data.containsKey('has_free_shipping')) {
      context.handle(
        _hasFreeShippingMeta,
        hasFreeShipping.isAcceptableOrUnknown(
          data['has_free_shipping']!,
          _hasFreeShippingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedDeal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedDeal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      originalPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}original_price'],
      )!,
      dealPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}deal_price'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      store: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      upvotes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}upvotes'],
      )!,
      downvotes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}downvotes'],
      )!,
      postedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}posted_at'],
      )!,
      isHot: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_hot'],
      )!,
      hasFreeShipping: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_free_shipping'],
      )!,
    );
  }

  @override
  $CachedDealsTable createAlias(String alias) {
    return $CachedDealsTable(attachedDatabase, alias);
  }
}

class CachedDeal extends DataClass implements Insertable<CachedDeal> {
  final String id;
  final String title;
  final String description;
  final double originalPrice;
  final double dealPrice;
  final String imageUrl;
  final String store;
  final String category;
  final int upvotes;
  final int downvotes;
  final DateTime postedAt;
  final bool isHot;
  final bool hasFreeShipping;
  const CachedDeal({
    required this.id,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.dealPrice,
    required this.imageUrl,
    required this.store,
    required this.category,
    required this.upvotes,
    required this.downvotes,
    required this.postedAt,
    required this.isHot,
    required this.hasFreeShipping,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['original_price'] = Variable<double>(originalPrice);
    map['deal_price'] = Variable<double>(dealPrice);
    map['image_url'] = Variable<String>(imageUrl);
    map['store'] = Variable<String>(store);
    map['category'] = Variable<String>(category);
    map['upvotes'] = Variable<int>(upvotes);
    map['downvotes'] = Variable<int>(downvotes);
    map['posted_at'] = Variable<DateTime>(postedAt);
    map['is_hot'] = Variable<bool>(isHot);
    map['has_free_shipping'] = Variable<bool>(hasFreeShipping);
    return map;
  }

  CachedDealsCompanion toCompanion(bool nullToAbsent) {
    return CachedDealsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      originalPrice: Value(originalPrice),
      dealPrice: Value(dealPrice),
      imageUrl: Value(imageUrl),
      store: Value(store),
      category: Value(category),
      upvotes: Value(upvotes),
      downvotes: Value(downvotes),
      postedAt: Value(postedAt),
      isHot: Value(isHot),
      hasFreeShipping: Value(hasFreeShipping),
    );
  }

  factory CachedDeal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedDeal(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      originalPrice: serializer.fromJson<double>(json['originalPrice']),
      dealPrice: serializer.fromJson<double>(json['dealPrice']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      store: serializer.fromJson<String>(json['store']),
      category: serializer.fromJson<String>(json['category']),
      upvotes: serializer.fromJson<int>(json['upvotes']),
      downvotes: serializer.fromJson<int>(json['downvotes']),
      postedAt: serializer.fromJson<DateTime>(json['postedAt']),
      isHot: serializer.fromJson<bool>(json['isHot']),
      hasFreeShipping: serializer.fromJson<bool>(json['hasFreeShipping']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'originalPrice': serializer.toJson<double>(originalPrice),
      'dealPrice': serializer.toJson<double>(dealPrice),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'store': serializer.toJson<String>(store),
      'category': serializer.toJson<String>(category),
      'upvotes': serializer.toJson<int>(upvotes),
      'downvotes': serializer.toJson<int>(downvotes),
      'postedAt': serializer.toJson<DateTime>(postedAt),
      'isHot': serializer.toJson<bool>(isHot),
      'hasFreeShipping': serializer.toJson<bool>(hasFreeShipping),
    };
  }

  CachedDeal copyWith({
    String? id,
    String? title,
    String? description,
    double? originalPrice,
    double? dealPrice,
    String? imageUrl,
    String? store,
    String? category,
    int? upvotes,
    int? downvotes,
    DateTime? postedAt,
    bool? isHot,
    bool? hasFreeShipping,
  }) => CachedDeal(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    originalPrice: originalPrice ?? this.originalPrice,
    dealPrice: dealPrice ?? this.dealPrice,
    imageUrl: imageUrl ?? this.imageUrl,
    store: store ?? this.store,
    category: category ?? this.category,
    upvotes: upvotes ?? this.upvotes,
    downvotes: downvotes ?? this.downvotes,
    postedAt: postedAt ?? this.postedAt,
    isHot: isHot ?? this.isHot,
    hasFreeShipping: hasFreeShipping ?? this.hasFreeShipping,
  );
  CachedDeal copyWithCompanion(CachedDealsCompanion data) {
    return CachedDeal(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      originalPrice: data.originalPrice.present
          ? data.originalPrice.value
          : this.originalPrice,
      dealPrice: data.dealPrice.present ? data.dealPrice.value : this.dealPrice,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      store: data.store.present ? data.store.value : this.store,
      category: data.category.present ? data.category.value : this.category,
      upvotes: data.upvotes.present ? data.upvotes.value : this.upvotes,
      downvotes: data.downvotes.present ? data.downvotes.value : this.downvotes,
      postedAt: data.postedAt.present ? data.postedAt.value : this.postedAt,
      isHot: data.isHot.present ? data.isHot.value : this.isHot,
      hasFreeShipping: data.hasFreeShipping.present
          ? data.hasFreeShipping.value
          : this.hasFreeShipping,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedDeal(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('originalPrice: $originalPrice, ')
          ..write('dealPrice: $dealPrice, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('store: $store, ')
          ..write('category: $category, ')
          ..write('upvotes: $upvotes, ')
          ..write('downvotes: $downvotes, ')
          ..write('postedAt: $postedAt, ')
          ..write('isHot: $isHot, ')
          ..write('hasFreeShipping: $hasFreeShipping')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    originalPrice,
    dealPrice,
    imageUrl,
    store,
    category,
    upvotes,
    downvotes,
    postedAt,
    isHot,
    hasFreeShipping,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedDeal &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.originalPrice == this.originalPrice &&
          other.dealPrice == this.dealPrice &&
          other.imageUrl == this.imageUrl &&
          other.store == this.store &&
          other.category == this.category &&
          other.upvotes == this.upvotes &&
          other.downvotes == this.downvotes &&
          other.postedAt == this.postedAt &&
          other.isHot == this.isHot &&
          other.hasFreeShipping == this.hasFreeShipping);
}

class CachedDealsCompanion extends UpdateCompanion<CachedDeal> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<double> originalPrice;
  final Value<double> dealPrice;
  final Value<String> imageUrl;
  final Value<String> store;
  final Value<String> category;
  final Value<int> upvotes;
  final Value<int> downvotes;
  final Value<DateTime> postedAt;
  final Value<bool> isHot;
  final Value<bool> hasFreeShipping;
  final Value<int> rowid;
  const CachedDealsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.originalPrice = const Value.absent(),
    this.dealPrice = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.store = const Value.absent(),
    this.category = const Value.absent(),
    this.upvotes = const Value.absent(),
    this.downvotes = const Value.absent(),
    this.postedAt = const Value.absent(),
    this.isHot = const Value.absent(),
    this.hasFreeShipping = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedDealsCompanion.insert({
    required String id,
    required String title,
    required String description,
    required double originalPrice,
    required double dealPrice,
    required String imageUrl,
    required String store,
    required String category,
    this.upvotes = const Value.absent(),
    this.downvotes = const Value.absent(),
    required DateTime postedAt,
    this.isHot = const Value.absent(),
    this.hasFreeShipping = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       originalPrice = Value(originalPrice),
       dealPrice = Value(dealPrice),
       imageUrl = Value(imageUrl),
       store = Value(store),
       category = Value(category),
       postedAt = Value(postedAt);
  static Insertable<CachedDeal> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<double>? originalPrice,
    Expression<double>? dealPrice,
    Expression<String>? imageUrl,
    Expression<String>? store,
    Expression<String>? category,
    Expression<int>? upvotes,
    Expression<int>? downvotes,
    Expression<DateTime>? postedAt,
    Expression<bool>? isHot,
    Expression<bool>? hasFreeShipping,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (originalPrice != null) 'original_price': originalPrice,
      if (dealPrice != null) 'deal_price': dealPrice,
      if (imageUrl != null) 'image_url': imageUrl,
      if (store != null) 'store': store,
      if (category != null) 'category': category,
      if (upvotes != null) 'upvotes': upvotes,
      if (downvotes != null) 'downvotes': downvotes,
      if (postedAt != null) 'posted_at': postedAt,
      if (isHot != null) 'is_hot': isHot,
      if (hasFreeShipping != null) 'has_free_shipping': hasFreeShipping,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedDealsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<double>? originalPrice,
    Value<double>? dealPrice,
    Value<String>? imageUrl,
    Value<String>? store,
    Value<String>? category,
    Value<int>? upvotes,
    Value<int>? downvotes,
    Value<DateTime>? postedAt,
    Value<bool>? isHot,
    Value<bool>? hasFreeShipping,
    Value<int>? rowid,
  }) {
    return CachedDealsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      originalPrice: originalPrice ?? this.originalPrice,
      dealPrice: dealPrice ?? this.dealPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      store: store ?? this.store,
      category: category ?? this.category,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      postedAt: postedAt ?? this.postedAt,
      isHot: isHot ?? this.isHot,
      hasFreeShipping: hasFreeShipping ?? this.hasFreeShipping,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (originalPrice.present) {
      map['original_price'] = Variable<double>(originalPrice.value);
    }
    if (dealPrice.present) {
      map['deal_price'] = Variable<double>(dealPrice.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (store.present) {
      map['store'] = Variable<String>(store.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (upvotes.present) {
      map['upvotes'] = Variable<int>(upvotes.value);
    }
    if (downvotes.present) {
      map['downvotes'] = Variable<int>(downvotes.value);
    }
    if (postedAt.present) {
      map['posted_at'] = Variable<DateTime>(postedAt.value);
    }
    if (isHot.present) {
      map['is_hot'] = Variable<bool>(isHot.value);
    }
    if (hasFreeShipping.present) {
      map['has_free_shipping'] = Variable<bool>(hasFreeShipping.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedDealsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('originalPrice: $originalPrice, ')
          ..write('dealPrice: $dealPrice, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('store: $store, ')
          ..write('category: $category, ')
          ..write('upvotes: $upvotes, ')
          ..write('downvotes: $downvotes, ')
          ..write('postedAt: $postedAt, ')
          ..write('isHot: $isHot, ')
          ..write('hasFreeShipping: $hasFreeShipping, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedDealIdsTable extends SavedDealIds
    with TableInfo<$SavedDealIdsTable, SavedDealId> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedDealIdsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dealIdMeta = const VerificationMeta('dealId');
  @override
  late final GeneratedColumn<String> dealId = GeneratedColumn<String>(
    'deal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [dealId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_deal_ids';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedDealId> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('deal_id')) {
      context.handle(
        _dealIdMeta,
        dealId.isAcceptableOrUnknown(data['deal_id']!, _dealIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dealIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dealId};
  @override
  SavedDealId map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedDealId(
      dealId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deal_id'],
      )!,
    );
  }

  @override
  $SavedDealIdsTable createAlias(String alias) {
    return $SavedDealIdsTable(attachedDatabase, alias);
  }
}

class SavedDealId extends DataClass implements Insertable<SavedDealId> {
  final String dealId;
  const SavedDealId({required this.dealId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['deal_id'] = Variable<String>(dealId);
    return map;
  }

  SavedDealIdsCompanion toCompanion(bool nullToAbsent) {
    return SavedDealIdsCompanion(dealId: Value(dealId));
  }

  factory SavedDealId.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedDealId(dealId: serializer.fromJson<String>(json['dealId']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'dealId': serializer.toJson<String>(dealId)};
  }

  SavedDealId copyWith({String? dealId}) =>
      SavedDealId(dealId: dealId ?? this.dealId);
  SavedDealId copyWithCompanion(SavedDealIdsCompanion data) {
    return SavedDealId(
      dealId: data.dealId.present ? data.dealId.value : this.dealId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedDealId(')
          ..write('dealId: $dealId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => dealId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedDealId && other.dealId == this.dealId);
}

class SavedDealIdsCompanion extends UpdateCompanion<SavedDealId> {
  final Value<String> dealId;
  final Value<int> rowid;
  const SavedDealIdsCompanion({
    this.dealId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedDealIdsCompanion.insert({
    required String dealId,
    this.rowid = const Value.absent(),
  }) : dealId = Value(dealId);
  static Insertable<SavedDealId> custom({
    Expression<String>? dealId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dealId != null) 'deal_id': dealId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedDealIdsCompanion copyWith({Value<String>? dealId, Value<int>? rowid}) {
    return SavedDealIdsCompanion(
      dealId: dealId ?? this.dealId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dealId.present) {
      map['deal_id'] = Variable<String>(dealId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedDealIdsCompanion(')
          ..write('dealId: $dealId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $CachedDealsTable cachedDeals = $CachedDealsTable(this);
  late final $SavedDealIdsTable savedDealIds = $SavedDealIdsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedDeals,
    savedDealIds,
  ];
}

typedef $$CachedDealsTableCreateCompanionBuilder =
    CachedDealsCompanion Function({
      required String id,
      required String title,
      required String description,
      required double originalPrice,
      required double dealPrice,
      required String imageUrl,
      required String store,
      required String category,
      Value<int> upvotes,
      Value<int> downvotes,
      required DateTime postedAt,
      Value<bool> isHot,
      Value<bool> hasFreeShipping,
      Value<int> rowid,
    });
typedef $$CachedDealsTableUpdateCompanionBuilder =
    CachedDealsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<double> originalPrice,
      Value<double> dealPrice,
      Value<String> imageUrl,
      Value<String> store,
      Value<String> category,
      Value<int> upvotes,
      Value<int> downvotes,
      Value<DateTime> postedAt,
      Value<bool> isHot,
      Value<bool> hasFreeShipping,
      Value<int> rowid,
    });

class $$CachedDealsTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedDealsTable> {
  $$CachedDealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get originalPrice => $composableBuilder(
    column: $table.originalPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dealPrice => $composableBuilder(
    column: $table.dealPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get store => $composableBuilder(
    column: $table.store,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get upvotes => $composableBuilder(
    column: $table.upvotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get downvotes => $composableBuilder(
    column: $table.downvotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get postedAt => $composableBuilder(
    column: $table.postedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHot => $composableBuilder(
    column: $table.isHot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasFreeShipping => $composableBuilder(
    column: $table.hasFreeShipping,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedDealsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedDealsTable> {
  $$CachedDealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get originalPrice => $composableBuilder(
    column: $table.originalPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dealPrice => $composableBuilder(
    column: $table.dealPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get store => $composableBuilder(
    column: $table.store,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get upvotes => $composableBuilder(
    column: $table.upvotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get downvotes => $composableBuilder(
    column: $table.downvotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get postedAt => $composableBuilder(
    column: $table.postedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHot => $composableBuilder(
    column: $table.isHot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasFreeShipping => $composableBuilder(
    column: $table.hasFreeShipping,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedDealsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedDealsTable> {
  $$CachedDealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get originalPrice => $composableBuilder(
    column: $table.originalPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get dealPrice =>
      $composableBuilder(column: $table.dealPrice, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get store =>
      $composableBuilder(column: $table.store, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get upvotes =>
      $composableBuilder(column: $table.upvotes, builder: (column) => column);

  GeneratedColumn<int> get downvotes =>
      $composableBuilder(column: $table.downvotes, builder: (column) => column);

  GeneratedColumn<DateTime> get postedAt =>
      $composableBuilder(column: $table.postedAt, builder: (column) => column);

  GeneratedColumn<bool> get isHot =>
      $composableBuilder(column: $table.isHot, builder: (column) => column);

  GeneratedColumn<bool> get hasFreeShipping => $composableBuilder(
    column: $table.hasFreeShipping,
    builder: (column) => column,
  );
}

class $$CachedDealsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedDealsTable,
          CachedDeal,
          $$CachedDealsTableFilterComposer,
          $$CachedDealsTableOrderingComposer,
          $$CachedDealsTableAnnotationComposer,
          $$CachedDealsTableCreateCompanionBuilder,
          $$CachedDealsTableUpdateCompanionBuilder,
          (
            CachedDeal,
            BaseReferences<_$LocalDatabase, $CachedDealsTable, CachedDeal>,
          ),
          CachedDeal,
          PrefetchHooks Function()
        > {
  $$CachedDealsTableTableManager(_$LocalDatabase db, $CachedDealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedDealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedDealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedDealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> originalPrice = const Value.absent(),
                Value<double> dealPrice = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String> store = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> upvotes = const Value.absent(),
                Value<int> downvotes = const Value.absent(),
                Value<DateTime> postedAt = const Value.absent(),
                Value<bool> isHot = const Value.absent(),
                Value<bool> hasFreeShipping = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedDealsCompanion(
                id: id,
                title: title,
                description: description,
                originalPrice: originalPrice,
                dealPrice: dealPrice,
                imageUrl: imageUrl,
                store: store,
                category: category,
                upvotes: upvotes,
                downvotes: downvotes,
                postedAt: postedAt,
                isHot: isHot,
                hasFreeShipping: hasFreeShipping,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                required double originalPrice,
                required double dealPrice,
                required String imageUrl,
                required String store,
                required String category,
                Value<int> upvotes = const Value.absent(),
                Value<int> downvotes = const Value.absent(),
                required DateTime postedAt,
                Value<bool> isHot = const Value.absent(),
                Value<bool> hasFreeShipping = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedDealsCompanion.insert(
                id: id,
                title: title,
                description: description,
                originalPrice: originalPrice,
                dealPrice: dealPrice,
                imageUrl: imageUrl,
                store: store,
                category: category,
                upvotes: upvotes,
                downvotes: downvotes,
                postedAt: postedAt,
                isHot: isHot,
                hasFreeShipping: hasFreeShipping,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedDealsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedDealsTable,
      CachedDeal,
      $$CachedDealsTableFilterComposer,
      $$CachedDealsTableOrderingComposer,
      $$CachedDealsTableAnnotationComposer,
      $$CachedDealsTableCreateCompanionBuilder,
      $$CachedDealsTableUpdateCompanionBuilder,
      (
        CachedDeal,
        BaseReferences<_$LocalDatabase, $CachedDealsTable, CachedDeal>,
      ),
      CachedDeal,
      PrefetchHooks Function()
    >;
typedef $$SavedDealIdsTableCreateCompanionBuilder =
    SavedDealIdsCompanion Function({required String dealId, Value<int> rowid});
typedef $$SavedDealIdsTableUpdateCompanionBuilder =
    SavedDealIdsCompanion Function({Value<String> dealId, Value<int> rowid});

class $$SavedDealIdsTableFilterComposer
    extends Composer<_$LocalDatabase, $SavedDealIdsTable> {
  $$SavedDealIdsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dealId => $composableBuilder(
    column: $table.dealId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedDealIdsTableOrderingComposer
    extends Composer<_$LocalDatabase, $SavedDealIdsTable> {
  $$SavedDealIdsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dealId => $composableBuilder(
    column: $table.dealId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedDealIdsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $SavedDealIdsTable> {
  $$SavedDealIdsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dealId =>
      $composableBuilder(column: $table.dealId, builder: (column) => column);
}

class $$SavedDealIdsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $SavedDealIdsTable,
          SavedDealId,
          $$SavedDealIdsTableFilterComposer,
          $$SavedDealIdsTableOrderingComposer,
          $$SavedDealIdsTableAnnotationComposer,
          $$SavedDealIdsTableCreateCompanionBuilder,
          $$SavedDealIdsTableUpdateCompanionBuilder,
          (
            SavedDealId,
            BaseReferences<_$LocalDatabase, $SavedDealIdsTable, SavedDealId>,
          ),
          SavedDealId,
          PrefetchHooks Function()
        > {
  $$SavedDealIdsTableTableManager(_$LocalDatabase db, $SavedDealIdsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedDealIdsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedDealIdsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedDealIdsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> dealId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedDealIdsCompanion(dealId: dealId, rowid: rowid),
          createCompanionCallback:
              ({
                required String dealId,
                Value<int> rowid = const Value.absent(),
              }) => SavedDealIdsCompanion.insert(dealId: dealId, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedDealIdsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $SavedDealIdsTable,
      SavedDealId,
      $$SavedDealIdsTableFilterComposer,
      $$SavedDealIdsTableOrderingComposer,
      $$SavedDealIdsTableAnnotationComposer,
      $$SavedDealIdsTableCreateCompanionBuilder,
      $$SavedDealIdsTableUpdateCompanionBuilder,
      (
        SavedDealId,
        BaseReferences<_$LocalDatabase, $SavedDealIdsTable, SavedDealId>,
      ),
      SavedDealId,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$CachedDealsTableTableManager get cachedDeals =>
      $$CachedDealsTableTableManager(_db, _db.cachedDeals);
  $$SavedDealIdsTableTableManager get savedDealIds =>
      $$SavedDealIdsTableTableManager(_db, _db.savedDealIds);
}
