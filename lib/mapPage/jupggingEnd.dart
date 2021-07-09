import 'dart:convert';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jupgging/models/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jupgging/mapPage/runningInfo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jupgging/provider/location_provider.dart';
import 'dart:io';
import 'dart:math' show cos, sqrt,asin;
import 'package:provider/provider.dart';
import 'dart:typed_data';

class JupggingEnd extends StatefulWidget {
  final RunningInfo run;
  final List<LatLng> route;
  final LatLng departure;
  final double distance;

  @override
  State<StatefulWidget> createState() => _JupggingEnd();
  //run = ModalRoute.of(context)!.settings.arguments as RunningInfo;
  //run = ModalRoute.of(context).settings.arguments;
  JupggingEnd({Key key, @required this.run, this.route, this.departure,this.distance}) : super(key: key);
}

class _JupggingEnd extends State<JupggingEnd> {
  File _image;
  Set<Polyline> lines = Set();
  List<LatLng> points = List();
  Set<Marker>_markers = Set();

  double distance=0.0; //거리
  LatLng start_point, end_point; //거리계산위한 시작점, 끝점받기

  FirebaseDatabase _database;
  DatabaseReference reference;
  String _databaseURL =
      'https://flutterproject-86abc-default-rtdb.asia-southeast1.firebasedatabase.app/';
  String id;


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
    final info = ModalRoute.of(context).settings.arguments as JupggingEnd;
    points = info.route; //경로 polyline point
    start_point = info.departure; //시작점
    distance= info.distance; //거리
    var m = info.run.minutes;
    var s = info.run.seconds;

    //시작위치 마커
    _markers.add(Marker(
        markerId: MarkerId("MyStartPosition"),
        position: LatLng(start_point.latitude, start_point.longitude),
        infoWindow: InfoWindow(title:'Start Position',snippet:'Start Running!!')
    ));

    return Scaffold(
      body: Container(
        child: Column(
            children: [
              //mapInfo((MediaQuery.of(context).size.height-50)*0.75),
              Container(  //지도 부분
                  color: Colors.white,
                  height: (MediaQuery.of(context).size.height-50)*0.85,
                  child: Center(
                    child:_image == null ? googleMapUI(): Image.file(File(_image.path)),
                  )
              ),
              Container(  //달린 거리, 시간 나오는 부분
                height: (MediaQuery.of(context).size.height-50)*0.15+50,
                color: Colors.white,
                child: Text('$distance km $m 분 $s 초',textAlign: TextAlign.center,style:TextStyle(fontSize: 20)),  //시간 계산
              ),
            ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectPhotoButton(context);
        },
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.lightBlueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                  onTap: () => _uploadImageToStorage(ImageSource .gallery),
                ),
              ],
            ),
          );
        });
  }

  Widget googleMapUI () {
    return Consumer<LocationProvider>(builder: ( //changeNotifer가 변경될때마다 호촐
        consumerContext,
        model,
        child
        ) {

      lines.add(
        Polyline(
          points: points,
          color: Colors.amber,
          polylineId: PolylineId("running route"),
        ),
      );

      if(model.locationPosition != null){

        end_point = model.locationPosition; //마지막 목적지 위치
        _markers.add(Marker( //도착위치 마커
            markerId: MarkerId("MyEndPosition"),
            position: LatLng(end_point.latitude, end_point.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(title:'End Position',snippet:'Finish Running!!')
        ));

        return Column(
          children:[
            Expanded(
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: model.locationPosition,
                      zoom: 16
                  ),
                  markers: _markers,
                  polylines: lines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (GoogleMapController controller){
                  },
                )
            )
          ],
        );
      }

      return Container(
        child : Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }


  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _profileImageURL = "";

  void _uploadImageToStorage(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);

    if (image == null) return;
    setState(() {
      _image = image;
    });

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
    reference
      .child(id)
      .push()
      .set(ImageURL(downloadURL,DateTime.now().toIso8601String()).toJson())
      .then((_) {
        print('url 저장완료');
    });
  }


}

