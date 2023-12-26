import 'package:flutter/material.dart';
import 'package:sqflie_learning/screens/note_details_screen.dart';
import 'package:sqflie_learning/screens/notes_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NoteKeeper",
      theme: ThemeData(primaryColor: Colors.deepOrange),
      home: NotesListScreen(),
    );
  }
}
