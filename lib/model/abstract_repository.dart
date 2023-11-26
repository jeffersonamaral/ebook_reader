import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../util/constants.dart';

abstract class AbstractRepository {

  @protected
  late Database database;

  @protected
  String favoriteTableName = 'favorite';

  @protected
  bool initialized = false;

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    database = await openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE $favoriteTableName(id INTEGER PRIMARY KEY, title TEXT, author TEXT, cover_url TEXT, download_url TEXT)',
        );
      },
      version: 1,
    );

    initialized = true;
  }

}