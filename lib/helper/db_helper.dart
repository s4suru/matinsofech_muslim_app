import 'package:sqflite/sqflite.dart';
import 'package:tasbih/models/note_model.dart';
import 'package:path/path.dart' as Path;
import 'package:tasbih/models/zikir_db_model.dart';


class DbHelper {
  static const String createTableNote = '''create table $tableNote(
  $tableNoteColId integer primary key autoincrement,
  $tableNoteColNote text)''';

  static const String createTableZikir = '''create table $tableZikir(
  $tableZikirColId integer primary key autoincrement,
  $tableZikirColDate text,
  $tableZikirColName text,
  $tableZikirColCount integer)''';

  static Future<Database> open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = Path.join(rootPath, 'note_db');

    return openDatabase(dbPath, version: 2, onCreate: (db, version) async{
      await db.execute(createTableNote);
      await db.execute(createTableZikir);
    });
  }

  static Future<int> insertNote(NoteModel noteModel) async {
    final db = await open();
    return db.insert(tableNote, noteModel.toMap());
  }

  static Future<int> insertZikir(ZikirModel zikirModel) async {
    final db = await open();
    return db.insert(tableZikir, zikirModel.toMap());
  }


  static Future<List<NoteModel>> getAllNotes() async {
    final db = await open();
    final mapList = await db.query(tableNote);
    return List.generate(mapList.length, (index) =>
        NoteModel.fromMap(mapList[index]));
  }

  static Future<int> deleteNotes() async {
    final db = await open();
    return db.delete(tableNote);
  }

  static Future<List<ZikirModel>> getAllZikirs() async {
    final db = await open();
    final mapList = await db.query(tableZikir);
    return List.generate(mapList.length, (index) =>
        ZikirModel.fromMap(mapList[index]));
  }

/*
  static Future<List<ZikirModel>> getZikirByName(String name) async {
    final db = await open();
    final mapList = await db.query(tableZikir,
        where: '$tableZikirColName = ?',
        whereArgs: [name],
    );
    return List.generate(mapList.length, (index) =>
        ZikirModel.fromMap(mapList[index]));
  }
*/

  Future<int> getTotalCountByName(String name) async {
    final db = await open();
    final result = await db.rawQuery(
        'SELECT SUM($tableZikirColCount) FROM $tableZikir WHERE $tableZikirColName = ?',
        [name]);
    return result.isNotEmpty ? result.first.values.first as int : 0;
  }


  static Future<int> getTotalCountByDate(String date) async {
    final db = await open();
    final result = await db.rawQuery(
        'SELECT SUM($tableZikirColCount) FROM $tableZikir WHERE $tableZikirColDate = ?',
        [date]);
    if (result.isNotEmpty && result.first.values.first != null) {
      return result.first.values.first as int;
    } else {
      return 0;
    }
  }
}