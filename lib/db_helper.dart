import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  ///to privatize your constructor
  DBHelper._();

  ///singleton object
  static DBHelper getInstance() => DBHelper._();

  ///open -> created? -> yes -> open -> no -> create -> open
  Database? mDB;

  Future<Database> getDB() async{
    return mDB ??= await openDB();

    /*if(mDB!=null){
      return mDB!;
    } else {
      mDB = await openDB();
      return mDB!;
    }*/
  }

  Future<Database> openDB() async{

    // /data/data/com.something.something/databases/mainDB.db
    var appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "mainDB.db");

    return await openDatabase(dbPath, version: 1, onCreate: (db, version){

      /// when db is created we need to create all the tables

      db.execute("create table note ( note_id integer primary key autoincrement, note_title text, note_desc text )");

    });

  }

  ///queries
  Future<bool> addNote({required String title, required String desc})async{
   var db = await getDB();

   int rowsEffected = await db.insert("note", {
     "note_title" : title,
     "note_desc" : desc
   });

   return rowsEffected>0;

  }

  Future<List<Map<String, dynamic>>> fetchAllNotes() async {
    var db = await getDB();
    ///select * from note
    List<Map<String, dynamic>> mData = await db.query("note");
    return mData;
  }
  

}