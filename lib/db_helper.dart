import 'package:db_exp_341/note_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  ///global static variables for table and columns
  ///tables
  static const String TABLE_NOTE = "note";
  ///columns
  static const String COLUMN_NOTE_ID = "note_id";
  static const String COLUMN_NOTE_TITLE = "note_title";
  static const String COLUMN_NOTE_DESC = "note_desc";



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

      db.execute("create table $TABLE_NOTE ( $COLUMN_NOTE_ID integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text )");

    });

  }

  ///queries (CRUD)
  ///insert
  Future<bool> addNote({required NoteModel newNote})async{
   var db = await getDB();

   int rowsEffected = await db.insert(TABLE_NOTE, newNote.toMap());

   return rowsEffected>0;

  }

  ///fetch
  Future<List<NoteModel>> fetchAllNotes() async {
    var db = await getDB();
    ///select * from note
    List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE);
    List<NoteModel> mNotes = [];

    for(int i = 0; i<mData.length; i++){
      NoteModel eachNote = NoteModel.fromMap(mData[i]);
      mNotes.add(eachNote);
    }

    return mNotes;
  }

  ///update
  Future<bool> updateNote({required NoteModel updateNote}) async{
    var db = await getDB();

    int rowsEffected = await db.update(TABLE_NOTE, updateNote.toMap(), where: "$COLUMN_NOTE_ID = ${updateNote.id}");

    return rowsEffected>0;
  }

  ///delete
  Future<bool> deleteNote({required int id}) async{
    var db = await getDB();

    int rowsEffected = await db.delete(TABLE_NOTE, where: "$COLUMN_NOTE_ID = $id");

    return rowsEffected>0;

  }
  

}