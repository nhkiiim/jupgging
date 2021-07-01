import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jupgging/mapPage/runningInfo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jupgging/provider/location_provider.dart';
import 'dart:io';
import 'dart:math' show cos, sqrt,asin;
import 'package:provider/provider.dart';

class JupggingEnd extends StatefulWidget {
  final RunningInfo run ;
  final List<LatLng> route;
  final LatLng spoint;

  @override
  State<StatefulWidget> createState() => _JupggingEnd();
  //run = ModalRoute.of(context)!.settings.arguments as RunningInfo;
  //run = ModalRoute.of(context).settings.arguments;
  JupggingEnd({Key key, @required this.run, this.route, this.spoint}) : super(key: key);
}

class _JupggingEnd extends State<JupggingEnd> {
  File _image;
  Set<Polyline> lines = Set();
  List<LatLng> points = List();
  Set<Marker>_markers = Set();

  double distance=0.0; //거리
  LatLng start_point,end_point; //거리계산위한 시작점, 끝점받기


  //final run = ModalRoute.of(context)!.settings.arguments as RunningInfo;

  void Photo(ImageSource source) async {
    File file = await ImagePicker.pickImage(source: source);
    setState(() => _image = file);
  }

  @override
  Widget build(BuildContext context) {
    final info = ModalRoute.of(context).settings.arguments as JupggingEnd;
    points = info.route; //polyline point
    start_point = info.spoint; //시작점 받기
    var m = info.run.minutes;
    var s = info.run.seconds;

    _markers.add(Marker( //시작위치 마커
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
                    child: googleMapUI(),
                  )
              ),
              Container(  //달린 거리, 시간 나오는 부분
                height: (MediaQuery.of(context).size.height-50)*0.15+50,
                color: Colors.white,
                child: Text('$m 분 $s 초',textAlign: TextAlign.center,style:TextStyle(fontSize: 20)),  //시간 계산
              ),]
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
                  onTap: () => Photo(ImageSource.gallery),
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
        if(distance == 0.0) {
          distance = double_coordinateDistance(
              start_point.latitude, start_point.longitude, end_point.latitude,
              end_point.longitude); //거리계산
          distance = double.parse(distance.toStringAsFixed(2)); //소수점 한자리
          print('거리 $distance km');
        }

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
                      zoom: 18
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

 double_coordinateDistance(lat1,lon1,lat2,lon2){
   var p = 0.017453292519943295;
   var c = cos;
   var a = 0.5 -
       c((lat2 - lat1) * p) / 2 +
       c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
   return 12742 * asin(sqrt(a));
 }

}

