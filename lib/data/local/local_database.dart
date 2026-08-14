import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'local_database.g.dart';

/// Cache local dos deals (usado para modo offline e para acelerar o
/// primeiro carregamento da Home). Espelha a entidade `Deal` descrita em
/// `achou_achado_api/api_report.md`.
class CachedDeals extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  RealColumn get originalPrice => real()();
  RealColumn get dealPrice => real()();
  TextColumn get imageUrl => text()();
  TextColumn get store => text()();
  TextColumn get category => text()();
  IntColumn get upvotes => integer().withDefault(const Constant(0))();
  IntColumn get downvotes => integer().withDefault(const Constant(0))();
  DateTimeColumn get postedAt => dateTime()();
  BoolColumn get isHot => boolean().withDefault(const Constant(false))();
  BoolColumn get hasFreeShipping =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// IDs de deals salvos pelo usuário, para funcionar sem internet.
class SavedDealIds extends Table {
  TextColumn get dealId => text()();

  @override
  Set<Column> get primaryKey => {dealId};
}

@DriftDatabase(tables: [CachedDeals, SavedDealIds])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'achou_achado.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
