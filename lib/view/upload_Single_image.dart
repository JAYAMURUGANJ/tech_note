import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Image')),
      body: Column(
        children: <Widget>[
          (imageUrl != null)
              ? Column(
                  children: [
                    Image.network(
                      imageUrl!,
                      height: 300.0,
                    ),
                    Text(imageUrl!)
                  ],
                )
              : Placeholder(
                  fallbackHeight: 200.0, fallbackWidth: double.infinity),
          SizedBox(
            height: 20.0,
          ),
          OutlinedButton(
            child: Text('Upload Image'),
            onPressed: () => uploadImage(),
          )
        ],
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
      var file = File(image!.path);
      //Upload to Firebase
      var snapshot =
          await _storage.ref().child('folderName/imageName2').putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();
      print(downloadUrl);

      setState(() {
        imageUrl = downloadUrl;
      });
    } else {
      print('Grant Permissions and try again');
    }
  }
}
