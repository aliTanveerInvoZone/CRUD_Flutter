/// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has four [BottomNavigationBarItem]
// widgets, which means it defaults to [BottomNavigationBarType.shifting], and
// the [currentIndex] is set to index 0. The selected item is amber in color.
// With each [BottomNavigationBarItem] widget, backgroundColor property is
// also defined, which changes the background color of [BottomNavigationBar],
// when that item is selected. The `_onItemTapped` function changes the
// selected item's index and displays a corresponding message in the center of
// the [Scaffold].

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:crud_app/Screens/View.dart';
import 'package:crud_app/Screens/Add.dart';

/// This is the stateful widget that the main application instantiates.
class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarRoute();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BottomBarRoute extends State<BottomBar> {
  static int selectedIndex = 0;
  static String selectedTitle = "";
  static String selectedDescription = "";
  static String docID = "";
  static bool isUpdate = false;

  void onAdd() {
    setState(() {
      selectedIndex = 1;
      selectedTitle = "";
      selectedDescription = "";
      isUpdate = false;
      docID = "";
    });
  }

  void onView(id, data) {
    print(data);
    setState(() {
      selectedTitle = data["title"];
      selectedDescription = data["Description"];
      isUpdate = true;
      docID = id;
      selectedIndex = 0;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Add(
          selectedTitle: selectedTitle,
          isUpdate: isUpdate,
          selectedDescription: selectedDescription,
          docID: docID,
          onAddSuccessfully: () {
            onAdd();
          }),
      View(
        onEditPress: (id, data) {
          onView(id, data);
        },
      )
    ];
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('CRUD APP '),
            ),
            body: Center(
              child: _widgetOptions.elementAt(selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Add',
                  backgroundColor: Colors.red,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.view_array),
                  label: 'View',
                  backgroundColor: Colors.green,
                ),
              ],
              currentIndex: selectedIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text("");
      },
    );
  }
}
