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
  File _image; //업로드할 사진
  FirebaseDatabase _database;
  DatabaseReference reference;
  String _databaseURL =
      'https://flutterproject-86abc-default-rtdb.asia-southeast1.firebasedatabase.app/';
  String id;
  TextEditingController _CommentController;

  void Photo(ImageSource source) async {
    File file = await ImagePicker.pickImage(source: source);
    setState(() => _image = file);
  }

  @override
  void initState() {
    super.initState();

    id = 'happy123';
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database.reference().child('image');

  }

  @override
  Widget build(BuildContext context) {
    ImageURL i = ModalRoute.of(context).settings.arguments;

    var m300=(MediaQuery.of(context).size.width)*0.7;
    var m40=(MediaQuery.of(context).size.height)*0.06;
    var m10=(MediaQuery.of(context).size.height)*0.03;
    var m20=(MediaQuery.of(context).size.height)*0.2;

    return Scaffold(
      body: SingleChildScrollView(
          child : Center(
            child: Column(
                children: [
                  Container(  //이미지
                      margin: EdgeInsets.fromLTRB(0, m20, 0, m10),
                      color: Colors.white,
                      height: m300,
                      width: m300,
                      child: Center(
                        child:_image == null ? Text(i.mapUrl) : Image.file(File(_image.path), fit: BoxFit.fill),
                      )
                  ),
                  Container(
                    child: Container(
                          height: m40,
                          width: m300,
                          child : TextField(
                              controller: _CommentController,
                              decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'comment',
                        )
                    )
                    ),
                  ),
                  Container(
                    child : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: m300/2-m300*0.03,
                            margin: EdgeInsets.fromLTRB(0,m10,0,0),
                            child : ElevatedButton(
                              onPressed: () => setState(() {_selectPhotoButton(context);}),
                              child: Text('album'),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFC5E99B), // background
                                onPrimary: Colors.white, // foreground
                              ),
                            )
                        ),
                        Container(
                            width: m300/2-m300*0.01,
                            margin: EdgeInsets.fromLTRB(m300*0.03,m10,0,0),
                            child : ElevatedButton(
                              onPressed: () {
                                _uploadImageToStorage(_image).then((value){
                                Navigator.of(context).pushReplacementNamed('/main/personal');
                                });
                                },
                              child: Text('upload'),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF8FBC94), // background
                                onPrimary: Colors.white, // foreground
                              ),
                            )
                        ),
                    ]
                  )
                  )
                ]
            ),
      )
      ),


    );
  }

  void _selectPhotoButton(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
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
                  onTap: () => Photo(ImageSource .gallery),
                ),
              ],
            ),
          );
        });
  }

  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _profileImageURL = "";

  Future<void> _uploadImageToStorage(File source) async {

    // 프로필 사진을 업로드할 경로와 파일명을 정의. 사용자의 uid를 이용하여 파일명의 중복 가능성 제거
    StorageReference storageReference =
    _firebaseStorage.ref().child("map/${DateTime.now().millisecondsSinceEpoch}.png");

    // 파일 업로드
    StorageUploadTask storageUploadTask = storageReference.putFile(_image);

    // 파일 업로드 완료까지 대기
    await storageUploadTask.onComplete;

    // 업로드한 사진의 URL 획득
    String downloadURL = await storageReference.getDownloadURL();

    // 업로드된 사진의 URL을 페이지에 반영
    setState(() {
      _profileImageURL = downloadURL;
    });

    //url을 db에 저장
    // reference
    //     .child(id)
    //     .push()
    //     .set(ImageURL(downloadURL,DateTime.now().toIso8601String()).toJson())
    //     .then((_) {
    //   print('url 저장완료');
    // });
  }


}


