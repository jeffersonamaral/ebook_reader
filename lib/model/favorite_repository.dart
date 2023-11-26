import 'package:sqflite/sqflite.dart';

import 'abstract_repository.dart';
import 'book_model.dart';
import 'favorite_model.dart';

class FavoriteRepository extends AbstractRepository {

  FavoriteRepository();

  void save(FavoriteModel favoriteModel) async {
    if (!initialized) {
      await initialize();
    }

    await database.insert(favoriteTableName, favoriteModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void delete(FavoriteModel favoriteModel) async {
    if (!initialized) {
      await initialize();
    }

    await database.delete(favoriteTableName,
      where: 'id = ?',
      whereArgs: [favoriteModel.id],
    );
  }

  Future<List<FavoriteModel>> findAll() async {
    if (!initialized) {
      await initialize();
    }

    final List<Map<String, dynamic>> maps = await database.query(favoriteTableName);

    return List.generate(maps.length, (i) {
        return FavoriteModel.fromMap(maps[i]);
    });
  }

}