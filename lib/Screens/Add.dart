import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/Services/database.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Add extends StatefulWidget {
  Add({
    required this.onAddSuccessfully,
    this.selectedTitle: "",
    this.selectedDescription: "",
    this.isUpdate: false,
    this.docID: '',
  });

  final Function onAddSuccessfully;
  final String selectedTitle;
  final String selectedDescription;
  final bool isUpdate;
  final String docID;

  @override
  Add_State createState() => Add_State();
}

// ignore: camel_case_types
class Add_State extends State<Add> {
  String Title = '';
  String Description = '';

  void onSucess() {
    setState(() {
      Title = "";
      Description = '';
    });
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Added Successfully"),
            ));
  }

  void _handleDialogSubmission() {
    widget.onAddSuccessfully();
    var task = <String, dynamic>{
      'title': Title,
      'Description': Description,
    };
    if (widget.isUpdate) {
      Database.updateTask(widget.docID, task)
          .then((value) => onSucess())
          .catchError((error) => print("Failed to add user: $error"));
    } else {
      Database.addTask(task)
          .then((value) => onSucess())
          .catchError((error) => print("Failed to add user: $error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference Blog = FirebaseFirestore.instance.collection('users');
    // Future<void> addItem() {
    //   return Blog.add({
    //     'title': Title,
    //     'Description': Description,
    //   })
    //       .then((value) => onSucess())
    //       .catchError((error) => print("Failed to add user: $error"));
    // }

    return Column(
      children: [
        Container(
          width: 300,
          margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          child: TextField(
            controller: TextEditingController(text: widget.selectedTitle),
            onChanged: (string) {
              Title = string;
            },
            decoration: InputDecoration(
              hintText: "Title",
              border: InputBorder.none,
              errorBorder: InputBorder.none,
            ),
          ),
        ),
        Container(
            width: 300,
            margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            child: TextField(
              controller:
                  TextEditingController(text: widget.selectedDescription),
              onChanged: (string) {
                Description = string;
              },
              decoration: InputDecoration(
                hintText: "Description",
                border: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 10,
            )),
        Container(
          width: 300,
          margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: Text("SUBMIT"),
            onPressed: () {
              setState(() {
                Title = Title;
                Description = Description;
              });
              _handleDialogSubmission();
            },
          ),
        )
      ],
    );
  }
}
