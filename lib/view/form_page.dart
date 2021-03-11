import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Create a Form widget
class MyCustomForm extends StatefulWidget {
  final String title;
  final String subtitle;
  final String id;

  MyCustomForm({this.title, this.subtitle, this.id});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleTEC = TextEditingController();
  final _subtitletownTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _titleTEC.text = widget.title != null ? widget.title : "";
    _subtitletownTEC.text = widget.subtitle != null ? widget.subtitle : "";
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? "Update Note" : "Add Note"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _titleTEC,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Enter Language Name',
                labelText: 'Name',
              ),
            ),
            TextFormField(
              controller: _subtitletownTEC,
              decoration: const InputDecoration(
                icon: const Icon(Icons.phone),
                hintText: 'Enter Subtitle',
                labelText: 'Subtitle',
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 150.0, top: 40.0),
              child: new TextButton(
                child: Text(widget.id != null ? "UPDATE" : "ADD"),
                onPressed: () {
                  if (widget.id != null) {
                    var data = {
                      'title': _titleTEC.text,
                      'subtitle': _subtitletownTEC.text
                    };
                    FirebaseFirestore.instance
                        .collection('NoteList')
                        .doc(widget.id)
                        .update(data);
                  } else {
                    FirebaseFirestore.instance.collection('NoteList').add({
                      'title': _titleTEC.text,
                      'subtitle': _subtitletownTEC.text
                    });
                  }

                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
