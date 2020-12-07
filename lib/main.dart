import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todoapp/model/Task.dart';
import 'package:flutter_todoapp/ui/Addtodos.dart';
import 'package:flutter_todoapp/utils/dimentions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);

  // final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> items;
  var _title = TextEditingController();
  var _description = TextEditingController();
  int index;
  List key;
  StreamSubscription<Event> _onNoteAddedSubscription, _onKeyAddedSubscription;

  final data = FirebaseDatabase.instance.reference().child("todolist");

  @override
  void initState() {
    super.initState();

    items = new List();
    key = new List();
    _onNoteAddedSubscription = data.onChildAdded.listen(_onNoteAdded);
    _onNoteAddedSubscription = data.onChildChanged.listen(_onEntryChanged);
  }

  void _onNoteAdded(Event event) {
    setState(() {
      items.add(Task.fromsnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var oldEntry = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      items[items.indexOf(oldEntry)] = Task.fromsnapshot(event.snapshot);
    });
  }

  @override
  void dispose() {
    _onNoteAddedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO App"),
          automaticallyImplyLeading: false,
      ),
      body: items.length == 0 ? Align(child:Text("You not added any events yet!",style: TextStyle(fontSize: twenty),) ,alignment: Alignment.center,):ListView.builder(
        itemCount: items.length,
        reverse: true,
        shrinkWrap: true,
        itemBuilder: (BuildContext c, index) {
          return Card(
              child: ListTile(
                  onLongPress: () => {
                        _showAlertDialogDelete(items[index].key,index),
                      },
                  title: Text(items[index].title),
                  subtitle: Text(items[index].description),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                      ),
                      onPressed: () => _showDialogUpdate(items[index].title,
                          items[index].description, items[index].key))));
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Addtodo()));
        },
        tooltip: 'ADD',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  delete(String key,int index) {
    data.child(key).remove().whenComplete(() => setState(() {
          setState(() {
            items.removeAt(index);
          });
        }));
    Navigator.of(context).pop();
  }

  _showDialogUpdate(var title, var descreption, String kay) async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        title: Text("Update data"),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new TextField(
              autofocus: true,
              controller: _title,
              decoration: new InputDecoration(
                labelText: title,
              ),
            ),
            new TextField(
              autofocus: true,
              controller: _description,
              decoration: new InputDecoration(
                labelText: descreption,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('UPDATE'),
              onPressed: () => {_updatedata(kay), Navigator.pop(context)})
        ],
      ),
    );
  }

  Future<void> _showAlertDialogDelete(String key ,int index ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Do you want to delete'),
          actions: <Widget>[
            FlatButton(
              child: Text('Delete'),
              onPressed: () {
                delete(key,index);
                // Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updatedata(String kay) async {
    try {
      DatabaseReference _userRef =
          FirebaseDatabase.instance.reference().child("todolist").child(kay);
      _userRef.reference().set({
        'title': _title.text,
        'descreption': _description.text,
      });

      _title.clear();
      _description.clear();
    } on Exception catch (_) {
      throw FirebaseDatabase;
    }
  }
}
