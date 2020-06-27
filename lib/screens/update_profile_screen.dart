import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:IUApp/method/firebase_methods.dart';
import 'package:IUApp/models/user.dart';
import 'package:IUApp/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class UpdateDPScreen extends StatefulWidget {
  UserModel currentCollectionUser;
  UpdateDPScreen({@required this.currentCollectionUser});

  @override
  _UpdateDPScreenState createState() => _UpdateDPScreenState();
}

class _UpdateDPScreenState extends State<UpdateDPScreen> {
  FirebaseMethods _methods = FirebaseMethods();
  bool isLoading = false;

  File _image;
  String _uploadedFileURL;

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
      _uploadedFileURL = "";
    });
  }

  updateDP() {
    widget.currentCollectionUser.profilephoto = _uploadedFileURL;
    _methods.updateProfile(
        widget.currentCollectionUser.uid, widget.currentCollectionUser);
  }

  removeDP() {
    widget.currentCollectionUser.profilephoto = "";
    _methods.updateProfile(
        widget.currentCollectionUser.uid, widget.currentCollectionUser);
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
        _uploadedFileURL = fileUrl;
        Navigator.pop(context);
      });
      updateDP();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {},
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
                      "Update DP",
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
                    FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.redAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "Remove Profile Photo",
                            style: signStyle,
                          ),
                        ),
                        onPressed: () {
                          removeDP();
                          Navigator.pop(context);
                        })
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
