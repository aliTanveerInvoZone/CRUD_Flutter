import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crud_app/Services/database.dart';

class View extends StatelessWidget {
  final Function onEditPress;

  View({
    required this.onEditPress,
  });

  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle descriptionStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.normal);

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        print(snapshot);
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot document = snapshot.data!.docs[index];

            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            return Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                margin:
                    new EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                padding:
                    new EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(children: [
                  Row(textDirection: TextDirection.ltr, children: [
                    Expanded(
                      flex: 7,
                      child:
                          Column(textDirection: TextDirection.ltr, children: [
                        Text(
                          data["title"],
                          style: titleStyle,
                        ),
                        Text(
                          data["Description"],
                          style: descriptionStyle,
                        ),
                      ]),
                    ),
                    Row(children: [
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            this.onEditPress(document.id, data);
                          }),
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            Database.deleteTask(document.id)
                                .then((value) => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("Deleted Successfully"),
                                        )));
                          })
                    ]),
                  ])
                ]));
          },
        );
      },
    );
  }
}
