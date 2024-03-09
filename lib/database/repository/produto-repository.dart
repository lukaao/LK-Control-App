import "package:lk/entity/produto.dart";
import "package:sqflite/sqflite.dart";
import "../configDb.dart";

class ProdutoRepository {
  static String tableName = "PRODUTOS";
  Database? _databaseProdutos;

  Future<Database> open() async {
    if (_databaseProdutos != null) {
      return _databaseProdutos!;
    }

    MyDataBase db = MyDataBase();

    _databaseProdutos = await db.open();

    return _databaseProdutos!;
  }

  Future<int> insert(Produto produto) async {
    final db = await open();
    return db.insert(tableName, produto.toMap());
  }

  Future<List<Produto>> get() async {
    final db = await open();
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return Produto.fromMap(maps[index]);
    });
  }

  Future<Produto?> getByCodProd(int codprod) async {
    final db = await open();
    final List<Map<String, dynamic>> maps =
        await db.query(tableName, where: "CODPROD = ?", whereArgs: [codprod]);
    if (maps.isNotEmpty) {
      return Produto.fromMap(maps[0]);
    }
    return null;
  }

  Future<List<Produto>> getByStatus() async {
    final db = await open();
    final List<Map<String, dynamic>> maps =
        await db.query(tableName, where: "STATUS = ?", whereArgs: [1]);
    return List.generate(maps.length, (index) {
      return Produto.fromMap(maps[index]);
    });
  }

  Future<void> update(Produto produto) async {
    final db = await open();
    await db.update(
      tableName,
      produto.toMap(),
      where: "ID = ?",
      whereArgs: [produto.id],
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
