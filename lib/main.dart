import 'package:db_exp_341/db_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper dbHelper = DBHelper.getInstance();

  List<Map<String, dynamic>> mNotes = [];

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  getNotes() async{
    mNotes = await dbHelper.fetchAllNotes();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: mNotes.isNotEmpty ? ListView.builder(
        itemCount: mNotes.length,
          itemBuilder: (_, index){
        return ListTile(
          title: Text(mNotes[index]["note_title"]),
          subtitle: Text(mNotes[index]["note_desc"]),
        );
      }) : Center(child: Text('No notes yet!!'),),
      floatingActionButton: FloatingActionButton(onPressed: (){
        /// add note
        dbHelper.addNote(title: "New Note", desc: "Live life KING size.");
        getNotes();
      }, child: Icon(Icons.add),),
    );
  }
}
