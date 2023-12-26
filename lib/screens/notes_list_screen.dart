import 'package:flutter/material.dart';
import 'package:sqflie_learning/database_helper.dart';
import 'package:sqflie_learning/screens/note_details_screen.dart';
import 'package:sqflite/sqlite_api.dart';

import '../models/notes_model.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  DataBaseHelper dbHelper = DataBaseHelper();
  List<Notes>? listOfNotes = [];
  int count = 0;
  @override
  void initState() {
    super.initState();
    printNoteDetailsList();
  }

  printNoteDetailsList() async {
    getUpdatedList();
    listOfNotes = await dbHelper.getNoteList();
    await dbHelper.getNoteList();
    print("${await dbHelper.getNoteList()}");
    setState(() {
      listOfNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NOTES"),
      ),
      body: getListNotes(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navToNextScreen("Add Details");
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getListNotes() {
    return ListView.builder(
        itemCount: listOfNotes!.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                navToNextScreen("Edit Details", listOfNotes?[index]);
              },
              child: Container(
                height: 100,
                color: Colors.pink,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        priorityColor(listOfNotes![index].priority!),
                    child: InkWell(
                      onTap: () {},
                      child: priorityIcon(listOfNotes![index].priority!),
                    ),
                  ),
                  title: Text(listOfNotes![index].title!),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listOfNotes![index].description ?? '',
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      Text(listOfNotes![index].date)
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      deleteNotes(listOfNotes![index], context);
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void navToNextScreen(String title, [Notes? noteDetails]) async {
    bool? result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NoteDetailsScreen(
        title: title,
        note: noteDetails,
      ),
    ));
    if (result == true) {
      getUpdatedList();
    }
  }

  //get priority color
  Color priorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  //get the priority icon
  Icon priorityIcon(int priority) {
    switch (priority) {
      case 1:
        return const Icon(Icons.play_arrow);
      case 2:
        return const Icon(Icons.keyboard_arrow_right);
      default:
        return const Icon(Icons.keyboard_arrow_right);
    }
  }

  //delete the notes
  void deleteNotes(Notes note, BuildContext context) async {
    var result = await dbHelper.deleteNotes(note.id!);
    if (result != 0) {
      showSnackBar();
      getUpdatedList();
    }
  }

  //show snack bar
  void showSnackBar() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("deleted successfully")));
  }

  //updated list
  void getUpdatedList() {
    final Future<Database> dbFuture = dbHelper.initializeDB();
    dbFuture.then((dataBase) {
      Future<List<Notes>> noteListFuture = dbHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          listOfNotes = noteList;
          count = noteList.length;
        });
      });
    });
  }
}
