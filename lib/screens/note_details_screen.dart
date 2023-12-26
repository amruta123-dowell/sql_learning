import 'package:flutter/material.dart';
import 'package:sqflie_learning/database_helper.dart';

import '../models/notes_model.dart';

class NoteDetailsScreen extends StatefulWidget {
  final String title;
  final Notes? note;
  const NoteDetailsScreen({required this.title, this.note, super.key});

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  List<String> listPriority = ["HIGH", "LOW"];

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String selectedPriority = '';
  final DataBaseHelper _dataBaseHelper = DataBaseHelper();
  // void onSelectPriority(String value) {
  //   setState(() {
  //     selectedPriority = value;
  //   });
  // }

  //covert the priority int to string
  void updatePriorityAsInt(String value) {
    selectedPriority = value;
    switch (value) {
      case "HIGH":
        widget.note?.priority = 1;
        break;
      case "LOW":
        widget.note?.priority = 2;
        break;
    }
  }

  //convert the int priority to string priority and display it to user in dropDown
  String getPriorityAsString(int value) {
    selectedPriority = '';
    switch (value) {
      case 1:
        selectedPriority = listPriority[0];
        break;
      case 2:
        selectedPriority = listPriority[1];
    }
    return selectedPriority;
  }

  ///update textfield details
  void updateTitle() {
    widget.note?.title = titleController.text;
  }

  void updateDescription() {
    widget.note?.description = descController.text;
  }

  ///ADD new data to the note list
  Future<void> saveNoteDetails() async {
    moveToLastScreen();
    int result;
    if (widget.note?.id != null) {
      result = await _dataBaseHelper.updateNotes(widget.note!);
    } else {
      Notes addNoteDetails = Notes(
          title: titleController.text,
          date: DateTime.now().toString(),
          priority: getPriorityInt(selectedPriority),
          description: descController.text);

      result = await _dataBaseHelper.insertNote(addNoteDetails);
    }
    if (result != 0) {
      //success
      showAlertDialog("STATUS", "The data is saved successfully....");
    } else {
      //failure
      showAlertDialog("STATUS", "The problem with data adding....");
    }
  }

  void showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  int getPriorityInt(String priority) {
    switch (priority) {
      case "LOW":
        return 2;
      case "HIGH":
        return 1;
      default:
        return 1;
    }
  }

  ///Delete the data
  void deleteData() async {
    moveToLastScreen();
    if (widget.note?.id == null) {
      showAlertDialog("STATUS", "No data was deleted...");
      return;
    }
    int result = await _dataBaseHelper.deleteNotes(widget.note!.id!);
    if (result != 0) {
      //success
      showAlertDialog("STATUS", "The details is deleted....");
    } else {
      showAlertDialog("STATUS", "The problem with deleting data...");
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  ///set details  to edit name note details
  void setEditDetails() {
    if (widget.note != null) {
      titleController.text = widget.note!.title!;
      descController.text = widget.note?.description ?? '';
      selectedPriority = getPriorityAsString(widget.note!.priority!);
    }
  }

  @override
  void initState() {
    selectedPriority = listPriority[0];
    setEditDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: <Widget>[
            DropdownButton(
                items: listPriority.map((String item) {
                  return DropdownMenuItem(value: item, child: Text(item));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    updatePriorityAsInt(value ?? listPriority[0]);
                  });
                },
                value: selectedPriority
                //  getPriorityAsString(widget.note?.priority ?? 1),
                ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
                onChanged: (_) {
                  updateTitle();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
                onChanged: (_) {
                  updateDescription();
                },
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            saveNoteDetails();
                          });
                          // await
                          // saveNoteDetails();
                        },
                        child: const Text("Save"))),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          deleteData();
                        },
                        child: const Text("Delete")))
              ],
            )
          ],
        ),
      ),
    );
  }
}
