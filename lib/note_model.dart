import 'package:db_exp_341/db_helper.dart';

class NoteModel {
  int id;
  String title;
  String desc;

  NoteModel({this.id = 0, required this.title, required this.desc});

  ///fromMap
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
        id: map[DBHelper.COLUMN_NOTE_ID],
        title: map[DBHelper.COLUMN_NOTE_TITLE],
        desc: map[DBHelper.COLUMN_NOTE_DESC],
    );
  }

  ///toMap
  Map<String, dynamic> toMap() {
    return {
      DBHelper.COLUMN_NOTE_TITLE: title,
      DBHelper.COLUMN_NOTE_DESC: desc,
    };
  }
}
