import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jupgging/mapPage/jupggingInfo.dart';
import 'package:jupgging/mapPage/runningInfo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jupgging/provider/location_provider.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class JupggingEnd extends StatefulWidget {
  final RunningInfo run ;
  final List<LatLng> route;

  @override
  State<StatefulWidget> createState() => _JupggingEnd();
  //run = ModalRoute.of(context)!.settings.arguments as RunningInfo;
  //run = ModalRoute.of(context).settings.arguments;
  JupggingEnd({Key key, @required this.run, this.route}) : super(key: key);
}

class _JupggingEnd extends State<JupggingEnd> {
  File _image;
  Set<Polyline> lines = Set();
  List<LatLng> points = List();
  //final run = ModalRoute.of(context)!.settings.arguments as RunningInfo;

  void Photo(ImageSource source) async {
    File file = await ImagePicker.pickImage(source: source);
    setState(() => _image = file);
  }

  @override
  Widget build(BuildContext context) {
    final info = ModalRoute.of(context).settings.arguments as JupggingEnd;
    points = info.route;

    var m = info.run.minutes;
    var s = info.run.seconds;

    return Scaffold(
      body: Container(
        child: Column(
            children: [
              //mapInfo((MediaQuery.of(context).size.height-50)*0.75),
              Container(  //지도 부분
                  color: Colors.lightGreen,
                  height: (MediaQuery.of(context).size.height-50)*0.75,
                  child: Center(
                    child: googleMapUI(),
                  )
              ),
              Container(  //달린 거리, 시간 나오는 부분
                height: (MediaQuery.of(context).size.height-50)*0.25+50,
                color: Colors.white,
                child: Text('$m 분 $s 초',textAlign: TextAlign.center,style:TextStyle(fontSize: 30)),  //시간 계산
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
        // st.start=model.locationPosition;
        // print('위치 ${st.start}');
        return Column(
          children:[
            Expanded(
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: model.locationPosition,
                      zoom: 18
                  ),
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

}

