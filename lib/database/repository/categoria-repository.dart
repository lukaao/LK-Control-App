import "package:lk/entity/categoria.dart";
import "package:sqflite/sqflite.dart";
import "../configDb.dart";

class CategoriaRepository {
  static String tableName = "Categoria";
  Database? _databaseCategoria;

  Future<Database> open() async {
    if (_databaseCategoria != null) {
      return _databaseCategoria!;
    }

    MyDataBase db = MyDataBase();

    _databaseCategoria = await db.open();

    return _databaseCategoria!;
  }

  Future<int> insert(Categoria categoria) async {
    final db = await open();
    return db.insert(tableName, categoria.toMap());
  }

  Future<List<Categoria>> get() async {
    final db = await open();
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return Categoria.fromMap(maps[index]);
    });
  }

  Future<Categoria?> getByCodCat(int codcat) async {
    final db = await open();
    final List<Map<String, dynamic>> maps =
        await db.query(tableName, where: "CODCAT = ?", whereArgs: [codcat]);
    if (maps.isNotEmpty) {
      return Categoria.fromMap(maps[0]);
    }
    return null;
  }

  Future<void> update(Categoria categoria) async {
    final db = await open();
    await db.update(
      tableName,
      categoria.toMap(),
      where: "ID = ?",
      whereArgs: [categoria.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await open();
    await db.delete(
      tableName,
      where: "ID = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteMany() async {
    final db = await open();
    await db.delete(
      tableName,
    );
  }
}
