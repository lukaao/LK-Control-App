import "package:lk/database/repository/aluguel-repository.dart";
import "package:lk/database/repository/categoria-repository.dart";
import "package:lk/database/repository/cliente-repository.dart";
import "package:lk/database/repository/faturar-repository.dart";
import "package:lk/database/repository/produto-repository.dart";
import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

class MyDataBase {
  Database? db;

  static dropDatabase() async {
    final dataBasePath = await getDatabasesPath();
    await deleteDatabase(join(dataBasePath, "lkcontrol.db"));
  }

  rawQuery(String query) async {
    final db = await open();
    return await db.rawQuery(query);
  }

  Future<Database> open() async {
    if (db != null) {
      return db!;
    }

    final dataBasePath = await getDatabasesPath();
    db = await openDatabase(
      join(dataBasePath, "lkcontrol.db"),
      onCreate: (db, version) async {
        for (var table in tables) {
          db.execute(table);
        }
      },
      version: 1,
    );
    return db!;
  }

  close() {
    if (db != null) {
      db?.close();
    }
  }

  List<String> tables = [
    """
CREATE TABLE ${CategoriaRepository.tableName} (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    CODCAT INTEGER,
    DESCRICAO TEXT,
    STATUS INTEGER,
    DATAINC DATETIME,
    DATAALT DATETIME
)
""",
    """
CREATE TABLE ${ProdutoRepository.tableName} (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  CODPROD INTEGER,
  CODIGO TEXT,
  DESCRICAO TEXT,
  STATUS INTEGER,
  CODCAT INTEGER,
  DATAINC DATETIME,
  DATAALT DATETIME
)
""",
    """
CREATE TABLE ${AluguelRepository.tableName} (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  CODALU INTEGER,
  CODPROD INTEGER,
  CODCLI INTEGER,
  STATUS INTEGER,
  PRECOINICIAL REAL,
  ENDERECO TEXT,
  DATAINICIO DATETIME,
  DATAFINAL DATETIME,
  DATAINC DATETIME,
  DATAALT DATETIME
)
""",
    """
CREATE TABLE ${ClienteRepository.tableName} (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  CODCLI INTEGER,
  NOME TEXT,
  CONTATO TEXT,
  DATAINC DATETIME,
  DATAALT DATETIME
)
""",
    """
CREATE TABLE ${FaturarRepository.tableName} (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  CODFAT INTEGER,
  CODALU INTEGER,
  CUSTO REAL,
  PRECOFINAL REAL,
  DATAFATURADO DATETIME,
  DATAINC DATETIME,
  DATAALT DATETIME
)
""",
  ];
}
