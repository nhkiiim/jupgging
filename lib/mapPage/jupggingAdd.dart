import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jupgging/models/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:jupgging/models/image.dart';

class JupggingAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _JupggingAdd();
}

class _JupggingAdd extends State<JupggingAdd> {
  File _image; // 업로드한 쓰레기 사진
  ImageURL imageURL;

  FirebaseDatabase _database;
  DatabaseReference referenceImg;
  String _databaseURL =
      'https://flutterproject-86abc-default-rtdb.asia-southeast1.firebasedatabase.app/';
  FirebaseStorage _firebaseStorage;

  String id;
  TextEditingController _commentTextController;

  void Photo(ImageSource source) async {
    File file = await ImagePicker.pickImage(source: source);
    setState(() => _image = file);
  }

  @override
  void initState() {
    super.initState();

    id = 'bcb123';
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    referenceImg = _database.reference().child('image');
    _firebaseStorage = FirebaseStorage.instance;

    _commentTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    imageURL = ModalRoute.of(context).settings.arguments;

    var m300 = (MediaQuery.of(context).size.width) * 0.7;
    var m40 = (MediaQuery.of(context).size.height) * 0.06;
    var m10 = (MediaQuery.of(context).size.height) * 0.03;
    var m20 = (MediaQuery.of(context).size.height) * 0.2;

    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
        child: Column(children: [
          Container(
              //이미지
              margin: EdgeInsets.fromLTRB(0, m20, 0, m10),
              color: Colors.white,
              height: m300,
              width: m300,
              child: Center(
                child: _image == null
                    ? Text('Image Upload')
                    : Image.file(File(_image.path), fit: BoxFit.cover),
              )),
          Container(
            child: Container(
                height: m40,
                width: m300,
                child: TextField(
                    controller: _commentTextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'comment',
                    ))),
          ),
          Container(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                width: m300 / 2 - m300 * 0.03,
                margin: EdgeInsets.fromLTRB(0, m10, 0, 0),
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    _selectPhotoButton(context);
                  }),
                  child: Text('image'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFC5E99B), // background
                    onPrimary: Colors.white, // foreground
                  ),
                )),
            Container(
                width: m300 / 2 - m300 * 0.01,
                margin: EdgeInsets.fromLTRB(m300 * 0.03, m10, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    _uploadImageToStorage(_image).then((value) {
                      Navigator.of(context)
                          .pushReplacementNamed('/main/personal');
                    });
                  },
                  child: Text('upload'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF8FBC94), // background
                    onPrimary: Colors.white, // foreground
                  ),
                )),
          ]))
        ]),
      )),
    );
  }

  void _selectPhotoButton(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text("사진 찍기"),
                  onTap: () => Photo(ImageSource.camera),
                ),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text("앨범에서 가져오기"),
                  onTap: () => Photo(ImageSource.gallery),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _uploadImageToStorage(File source) async {
    // 프로필 사진을 업로드할 경로와 파일명을 정의.
    StorageReference storageReference = _firebaseStorage
        .ref()
        .child("trash/${DateTime.now().millisecondsSinceEpoch}.png");

    // 파일 업로드
    StorageUploadTask storageUploadTask = storageReference.putFile(_image);

    // 파일 업로드 완료까지 대기
    await storageUploadTask.onComplete;

    // 업로드한 사진의 URL 획득
    String downloadURL = await storageReference.getDownloadURL();

    //trashUrl, comment를 db에 저장
    ImageURL upImageURL = ImageURL(
        imageURL.mapUrl,
        downloadURL,
        imageURL.distance,
        imageURL.time,
        _commentTextController.value.text,
        imageURL.createTime);

    referenceImg
        .child(id)
        .child(imageURL.key)
        .set(upImageURL.toJson())
        .then((_) {
      print('업데이트 완료');
    });
  }
}
