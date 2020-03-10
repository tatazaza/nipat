import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nipat/src/pages/home_page/home.dart';
import 'package:nipat/src/utils/constant.dart';

class EditInsertImagePage extends StatefulWidget {
  final String docID;

  final String studentID;
  EditInsertImagePage({
    Key key,
    this.docID,
    this.studentID,
  }) : super(key: key);

  @override
  _EditInsertImagePageState createState() => _EditInsertImagePageState();
}

class _EditInsertImagePageState extends State<EditInsertImagePage> {
  File _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constant.INSERT),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 100.0,
                          width: 274.0,
                          child: Center(
                            child: _image == null
                                ? const Text('กรุณาเลือกรูปภาพ')
                                : Image.file(_image),
                          ),
                        ),
                        RaisedButton(
                          onPressed: getImageFromCam,
                          child: Icon(Icons.add_a_photo),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitForm,
        child: Icon(Icons.file_upload),
      ),
    );
  }

  Future getImageFromCam() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<String> _onImageUploader(File imagePath, String studentId) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('$studentId.png');
    final StorageUploadTask task = firebaseStorageRef.putFile(imagePath);
    StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void _submitForm() async {
    String _imageUrl = await _onImageUploader(_image, widget.studentID);

    if (_imageUrl != null) {
      await Firestore.instance
          .collection('students')
          .document(widget.docID)
          .updateData({
        "image": _imageUrl,
      });
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomePage();
        },
      ),
    );
  }
}
