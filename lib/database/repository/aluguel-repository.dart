import "package:lk/entity/aluguel.dart";
import "package:sqflite/sqflite.dart";
import "../configDb.dart";

class AluguelRepository {
  static String tableName = "ALUGUEIS";
  Database? _databaseAluguels;

  Future<Database> open() async {
    if (_databaseAluguels != null) {
      return _databaseAluguels!;
    }

    MyDataBase db = MyDataBase();

    _databaseAluguels = await db.open();

    return _databaseAluguels!;
  }

  Future<int> insert(Aluguel aluguel) async {
    final db = await open();
    return db.insert(tableName, aluguel.toMap());
  }

  Future<List<Aluguel>> get() async {
    final db = await open();
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return Aluguel.fromMap(maps[index]);
    });
  }

  Future<List<Aluguel>> getByCodProd(int codprod) async {
    final db = await open();
    final List<Map<String, dynamic>> maps =
        await db.query(tableName, where: "CODPROD = ?", whereArgs: [codprod]);
    return List.generate(maps.length, (index) {
      return Aluguel.fromMap(maps[index]);
    });
  }

  Future<Aluguel?> getByCodAlu(int codAlu) async {
    final db = await open();
    final List<Map<String, dynamic>> maps =
        await db.query(tableName, where: "CODALU = ?", whereArgs: [codAlu]);
    if (maps.isNotEmpty) {
      return Aluguel.fromMap(maps[0]);
    }
    return null;
  }

  Future<void> update(Aluguel aluguel) async {
    final db = await open();
    await db.update(
      tableName,
      aluguel.toMap(),
      where: "ID = ?",
      whereArgs: [aluguel.id],
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
