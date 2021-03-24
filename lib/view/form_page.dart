import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

// Create a Form widget
// ignore: must_be_immutable
class MyCustomForm extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final String? id;
  String? imgUrl;

  MyCustomForm({this.title, this.subtitle, this.id, this.imgUrl});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleTEC = TextEditingController();
  final _subtitletownTEC = TextEditingController();
  String? imageUrl;
  bool imageLoding = false;
  @override
  Widget build(BuildContext context) {
    _titleTEC.text = widget.title != null ? widget.title! : "";
    _subtitletownTEC.text = widget.subtitle != null ? widget.subtitle! : "";
    print(widget.imgUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? "Update Note" : "Add Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Poster",
                style: TextStyle(color: Colors.black54, fontSize: 18.0),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    (widget.imgUrl != null)
                        ? Image.network(
                            widget.imgUrl!,
                            width: 250,
                            height: 100.0,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYB4fmJMs3cQZEg1WwaCX4_ViLyR7gbkSsnQ&usqp=CAU",
                            width: 250,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),

                    //Placeholder(
                    // fallbackHeight: 100.0, fallbackWidth: 250.0),
                    SizedBox(
                      height: 20.0,
                    ),
                    OutlinedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.imgUrl != null
                              ? "Edit \n Image"
                              : "Upload \n Image",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onPressed: () => uploadImage(),
                    ),
                  ],
                ),
              ),
              imageLoding != false
                  ? Column(
                      children: [
                        Center(child: CircularProgressIndicator()),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 10.0,
                    ),
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
                child: new OutlinedButton(
                  child: Text(widget.id != null ? "UPDATE" : "ADD"),
                  onPressed: () {
                    var data = {
                      'title': _titleTEC.text,
                      'subtitle': _subtitletownTEC.text,
                      'image': widget.imgUrl
                    };
                    if (widget.id != null) {
                      FirebaseFirestore.instance
                          .collection('NoteList')
                          .doc(widget.id)
                          .update(data);
                    } else {
                      FirebaseFirestore.instance
                          .collection('NoteList')
                          .add(data);
                    }

                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile? image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        imageLoding = true;
      });
      var file = File(image!.path);
      //Upload to Firebase
      var imagename = Random().nextInt(10000).toString();
      var snapshot =
          await _storage.ref().child('folderName/$imagename').putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      //print(downloadUrl);
      setState(() {
        widget.imgUrl = downloadUrl;
        imageLoding = false;
      });
    } else {
      print('Grant Permissions and try again');
    }
  }
}
