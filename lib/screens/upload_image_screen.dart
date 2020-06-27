import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:IUApp/models/image_model.dart';
import 'package:IUApp/utils/utils.dart';

class UploadScreen extends StatefulWidget {
  String userID;
  UploadScreen({@required this.userID});
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File _image;
  bool isLoading = false;
  FocusNode hashNode = FocusNode();
  FocusNode nameNode = FocusNode();
  TextEditingController hashTagController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  openOptions() async {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        backgroundColor: Colors.white12,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.photo,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Gallery",
                    style: signStyle,
                  ),
                  onTap: () async {
                    await ImagePicker.pickImage(source: ImageSource.gallery)
                        .then((image) {
                      setState(() {
                        Navigator.pop(context);
                        _image = image;
                      });
                    });
                  },
                ),
                Divider(
                  color: Colors.deepPurpleAccent,
                  thickness: 2,
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Camera",
                    style: signStyle,
                  ),
                  onTap: () async {
                    await ImagePicker.pickImage(source: ImageSource.camera)
                        .then((image) {
                      setState(() {
                        Navigator.pop(context);
                        _image = image;
                      });
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  clearSection() {
    setState(() {
      _image = null;
    });
  }

  uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileUrl) {
      setState(() {
        isLoading = false;
//        _uploadedFileURL = fileUrl;
        ImageModel imageModel = ImageModel(
            uid: widget.userID,
            image_url: fileUrl,
            name: nameController.text,
            hashtag: hashTagController.text,
            time: DateTime.now());
        Firestore.instance
            .collection("Image_Collection")
            .add(imageModel.toJson());
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.blue,
                  Colors.deepPurple,
                  Colors.deepPurpleAccent
                ])),
            child: Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Share Image",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'Pacifico'),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        height: 200,
                        color: Colors.white12,
                        child: _image != null
                            ? Image.file(_image)
                            : Center(
                                child: Text(
                                  "No Image Selected",
                                  style: labelStyle,
                                ),
                              )),
                    SizedBox(
                      height: 20,
                    ),
                    _image != null
                        ? TextField(
                            focusNode: hashNode,
                            controller: hashTagController,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (str) {
                              FocusScope.of(context).requestFocus(nameNode);
                            },
                            style: labelStyle,
                            decoration: InputDecoration(
                                labelText: "Hashtags",
                                labelStyle: labelStyle,
                                enabledBorder: labelBorder,
                                fillColor: Colors.white12,
                                filled: true,
                                border: labelBorder,
                                focusedBorder: labelBorder),
                          )
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                    _image != null
                        ? TextField(
                            focusNode: nameNode,
                            controller: nameController,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (str) {
                              FocusScope.of(context).unfocus();
                            },
                            style: labelStyle,
                            decoration: InputDecoration(
                                labelText: "Photo Name",
                                labelStyle: labelStyle,
                                enabledBorder: labelBorder,
                                fillColor: Colors.white12,
                                filled: true,
                                border: labelBorder,
                                focusedBorder: labelBorder),
                          )
                        : Container(),
                    SizedBox(height: 20),
                    _image == null
                        ? FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.white12,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Choose File",
                                style: signStyle,
                              ),
                            ),
                            onPressed: openOptions,
                          )
                        : Container(),
                    !isLoading && _image != null
                        ? FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.white12,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Upload",
                                style: signStyle,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                                uploadFile();
                              });
                            },
                          )
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                    _image != null
                        ? FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.white12,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Clear",
                                style: signStyle,
                              ),
                            ),
                            onPressed: clearSection,
                          )
                        : Container(),
                    SizedBox(height: 30),
                  ],
                ),
                isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Uploading..",
                              style: signStyle,
                            ),
                            CircularProgressIndicator()
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
