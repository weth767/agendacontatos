import 'package:agendacontatos/model/contact.dart';
import 'package:agendacontatos/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContactRepository {
  static final ContactRepository _instance = ContactRepository.internal();
  factory ContactRepository() => _instance;
  ContactRepository.internal();
  Database? _database;

  Future<Database>_inicializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contacts.db");
    return await openDatabase(path, version: 1, onCreate: (Database database, int newerVersion) async {
      await database.execute(SQL);
    });
  }
  
  Future<Database> get getConnection async {
    if (_database == null) {
      _database = await _inicializeDatabase();
    }
    return Future.value(_database);
  }

  Future<Contact> save(Contact contact) async {
    Database db = await getConnection;
    contact.id = await db.insert(TABLENAME, contact.toMap());
    return contact;
  }

  Future<Contact> get(int id) async{
    Database db = await getConnection;
    List<Map<String, Object?>> maps = await db.query(TABLENAME, 
    columns: [IDCOLUMN, NAMECOLUMN, EMAILCOLUMN, PHONECOLUMN, IMAGECOLUMN],
    where: "$IDCOLUMN = ?",
    whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Contact.fromMap(maps.first);
    }
    return Future.value(null);
  }

  Future<int> delete(int id) async {
    Database db = await getConnection;
    return await db.delete(TABLENAME, where: "$IDCOLUMN = ?", whereArgs: [id]);
  }

  Future<int> update(Contact contact) async {
    Database db = await getConnection;
    return await db.update(TABLENAME, contact.toMap(),
    where: "$IDCOLUMN = ?",
    whereArgs: [contact.id]);
  }

  Future<List<Contact>> getAll() async {
    Database db = await getConnection;
    List<Map<String, Object?>> data = await db.rawQuery("SELECT * FROM $TABLENAME");
    return data.map((e) => Contact.fromMap(e)).toList();
  }

  Future<int?> count() async {
    Database db = await getConnection;
    return Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $TABLENAME"));
  }

  Future<void> close() async {
    Database db = await getConnection;
    await db.close();
  }
}

