import 'package:db_exp_341/db_helper.dart';
import 'package:db_exp_341/note_model.dart';
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
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  DBHelper dbHelper = DBHelper.getInstance();

  List<NoteModel> mNotes = [];

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  getNotes() async {
    mNotes = await dbHelper.fetchAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: mNotes.isNotEmpty
          ? ListView.builder(
              itemCount: mNotes.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${index + 1}"),
                      SizedBox(
                        width: 11,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mNotes[index].title, style: TextStyle(fontSize: 20,),),
                          Text(mNotes[index].desc, style: TextStyle(fontSize: 14, color: Colors.grey),),
                        ],
                      ),
                      Expanded(child: Container()),
                      SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () async {
                                  /// edit note
                                  bool check = await dbHelper.updateNote(updateNote: NoteModel(id: mNotes[index].id, title: mNotes[index].title, desc: mNotes[index].desc));
                                  if (check) {
                                    getNotes();
                                  }
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () async {
                                  /// remove note
                                  bool check = await dbHelper.deleteNote(
                                      id: mNotes[index].id);
                                  if (check) {
                                    getNotes();
                                  }
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                );

                /*ListTile(
          leading: Text("${index+1}"),
          title: Text(mNotes[index]["note_title"]),
          subtitle: Text(mNotes[index]["note_desc"]),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(onPressed: () async{
                  /// edit note
                  bool check = await dbHelper.updateNote(updatedTitle: "Updated Note", updatedDesc: "Consistency is the key to SUCCESS", id: mNotes[index]["note_id"]);
                  if(check){
                    getNotes();
                  }
                }, icon: Icon(Icons.edit)),
                IconButton(onPressed: () async{
                  /// remove note
                  bool check = await dbHelper.deleteNote(id: mNotes[index]["note_id"]);
                  if(check){
                    getNotes();
                  }
                }, icon: Icon(Icons.delete, color: Colors.red,))
              ],
            ),
          ),
        );*/
              })
          : Center(
              child: Text('No notes yet!!'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          /// add note
          titleController.text = "";
          descController.clear();
          showModalBottomSheet(
              //isDismissible: false,
              //enableDrag: false,
              context: context,
              builder: (_) {
                return Container(
                  padding: EdgeInsets.all(11),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        'Add Note',
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                            hintText: "Enter title here..",
                            label: Text('Title'),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                            )),
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      TextField(
                        controller: descController,
                        minLines: 4,
                        maxLines: 6,
                        decoration: InputDecoration(
                            hintText: "Enter desc here..",
                            label: Text('Desc'),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                            )),
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                              onPressed: () async {
                                bool check = await dbHelper.addNote(newNote: NoteModel(title: titleController.text, desc: descController.text));
                                if (check) {
                                  getNotes();
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Add')),
                          OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'))
                        ],
                      )
                    ],
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
