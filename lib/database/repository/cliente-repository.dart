import "package:lk/entity/cliente.dart";
import "package:sqflite/sqflite.dart";
import "../configDb.dart";

class ClienteRepository {
  static String tableName = "CLIENTES";
  Database? _databaseClientes;

  Future<Database> open() async {
    if (_databaseClientes != null) {
      return _databaseClientes!;
    }

    MyDataBase db = MyDataBase();

    _databaseClientes = await db.open();

    return _databaseClientes!;
  }

  Future<int> insert(Cliente cliente) async {
    final db = await open();
    return db.insert(tableName, cliente.toMap());
  }

  Future<List<Cliente>> get() async {
    final db = await open();
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return Cliente.fromMap(maps[index]);
    });
  }

  Future<Cliente?> getByCodCli(int codCli) async {
    final db = await open();
    final List<Map<String, dynamic>> maps =
        await db.query(tableName, where: "CODCLI = ?", whereArgs: [codCli]);
    if (maps.isNotEmpty) {
      return Cliente.fromMap(maps[0]);
    }
    return null;
  }

  Future<void> update(Cliente cliente) async {
    final db = await open();
    await db.update(
      tableName,
      cliente.toMap(),
      where: "ID = ?",
      whereArgs: [cliente.id],
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
