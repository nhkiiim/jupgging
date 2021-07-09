import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:jupgging/models/user.dart';
import 'package:jupgging/models/image.dart';

class PersonalBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PersonalBoard();
}

class _PersonalBoard extends State<PersonalBoard> {
  List<ImageURL> _imgUrl = List();
  String id;
  User user;
  FirebaseDatabase _database;
  DatabaseReference reference;
  DatabaseReference referenceImg;
  String _databaseURL =
      'https://flutterproject-86abc-default-rtdb.asia-southeast1.firebasedatabase.app/';

  @override
  void initState() {
    super.initState();
    id = 'happy123';

    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database.reference().child('user');
    referenceImg = _database.reference().child('image');

    // ImageDownload().then((value)=>{
    //   setState(() {_imgUrl = value;})
    // });
    referenceImg.child(id).onChildAdded.listen((event) {
      print(event.snapshot.value.toString());
      setState(() {
        _imgUrl.add(ImageURL.fromSnapshot(event.snapshot));
      });
    });
  }

  // Future<List> ImageDownload() async{
  //   FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  //   StorageReference storageReference = _firebaseStorage.ref().child("map/1625230581747.png");
  //   String downloadImg = await storageReference.getDownloadURL();
  //   StorageReference storageReference1 = _firebaseStorage.ref().child("map/1625239722429.png");
  //   String downloadImg1 = await storageReference1.getDownloadURL();
  //   print(downloadImg1);
  //   List a=[downloadImg,downloadImg1];
  //   return a;
  // }
  GridView _imageGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: [
        Image.network(_imgUrl[0].url, fit: BoxFit.fill),
        Image.network(_imgUrl[1].url, fit: BoxFit.fill)
      ],
    );
  }

  Widget build(BuildContext context) {
    _imgUrl = List.from(_imgUrl.reversed);
    print('ddddddd' + _imgUrl[0].url);
    return Scaffold(
      body: Container(
        child: Column(children: [
          Container(
            color: Colors.deepOrange,
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(35, 35, 35, 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(55.0),
                        child: Image.asset(
                          'image/tree.jpg',
                          width: 90,
                          height: 90,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                        child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(30, 50, 35, 20),
                            child: Text("Running",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                        Padding(
                            padding: EdgeInsets.fromLTRB(35, 0, 35, 20),
                            child: Text("10km",
                                style: TextStyle(color: Colors.white))),
                      ],
                    )),
                    Container(
                        child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 50, 35, 20),
                            child: Text("Time",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 35, 20),
                            child: Text("14h",
                                style: TextStyle(color: Colors.white))),
                      ],
                    )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                  child: RaisedButton(
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.settings,
                          color: Colors.deepOrange,
                        ),
                        Text('  setting',
                            style: TextStyle(color: Colors.deepOrange))
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    onPressed: () {
                      reference.child(id).onChildAdded.listen((event) {
                        user = User.fromSnapshot(event.snapshot);
                        Navigator.of(context)
                            .pushNamed('/mypage', arguments: user);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          _imgUrl.length == 0
              ? CircularProgressIndicator()
              : Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        //child: GridTile(
                        child: Container(
                          //width: 200,
                          //padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: SizedBox(
                            child: GestureDetector(
                              onTap: () {
                                //누르면 인스타 개인 게시물처럼 보기
                              },
                              child:
                                  // Text('ddd'),
                                  Image.network(_imgUrl[index].url,
                                      fit: BoxFit.fill),
                            ),
                          ),
                        ),
                        //),
                      );
                    },
                    itemCount: _imgUrl.length,
                  ),
                ),
        ]),
      ),
    );
  }
}
