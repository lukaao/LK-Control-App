import "package:lk/entity/cliente.dart";
import "package:lk/entity/faturar.dart";
import "package:sqflite/sqflite.dart";
import "../configDb.dart";

class FaturarRepository {
  static String tableName = "FATURAR";
  Database? _databaseClientes;

  Future<Database> open() async {
    if (_databaseClientes != null) {
      return _databaseClientes!;
    }

    MyDataBase db = MyDataBase();

    _databaseClientes = await db.open();

    return _databaseClientes!;
  }

  Future<int> insert(Faturar cliente) async {
    final db = await open();
    return db.insert(tableName, cliente.toMap());
  }

  Future<List<Faturar>> get() async {
    final db = await open();
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return Faturar.fromMap(maps[index]);
    });
  }

  Future<List<Faturar>> getByDate(DateTime data) async {
    final db = await open();

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'DATAFATURADO >= ?',
      whereArgs: [data.toIso8601String()],
    );

    return List.generate(maps.length, (index) {
      return Faturar.fromMap(maps[index]);
    });
  }

  Future<Faturar?> getByCodFat(int codFat) async {
    final db = await open();
    final List<Map<String, dynamic>> maps =
        await db.query(tableName, where: "CODFAT = ?", whereArgs: [codFat]);
    if (maps.isNotEmpty) {
      return Faturar.fromMap(maps[0]);
    }
    return null;
  }

  Future<Faturar?> getByCodAlu(int codAlu) async {
    final db = await open();
    final List<Map<String, dynamic>> maps =
        await db.query(tableName, where: "CODALU = ?", whereArgs: [codAlu]);
    if (maps.isNotEmpty) {
      return Faturar.fromMap(maps[0]);
    }
    return null;
  }

  Future<void> update(Faturar faturar) async {
    final db = await open();
    await db.update(
      tableName,
      faturar.toMap(),
      where: "ID = ?",
      whereArgs: [faturar.id],
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
