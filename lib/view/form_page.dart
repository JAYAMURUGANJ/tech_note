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
    //print(widget.imgUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? "Update Note" : "Add Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
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
                  child: GestureDetector(
                    onTap: () => uploadImage(),
                    child: SizedBox(
                      height: 250,
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              color: Colors.white,
                              child: (widget.imgUrl != null)
                                  ? Image.network(
                                      widget.imgUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      "https://png.pngtree.com/png-vector/20191129/ourmid/pngtree-image-upload-icon-photo-upload-icon-png-image_2047546.jpg",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5.0),
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Colors.black.withAlpha(0),
                                  Colors.black12,
                                  Colors.black45
                                ],
                              ),
                            ),
                            child: Text(
                              widget.id != null ? "Edit Image" : "Upload Image",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                        ],
                      ),
                    ),
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
        image != null ? imageLoding = true : imageLoding = false;
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
