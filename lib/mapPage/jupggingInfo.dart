import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jupgging/mapPage/firstPage.dart';
import 'package:jupgging/provider/location_provider.dart';
import 'dart:async';
import 'package:jupgging/mapPage/runningInfo.dart';
import 'package:jupgging/mapPage/jupggingEnd.dart';
import 'package:provider/provider.dart';

import 'location.dart';

class JupggingInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _JupggingInfo();
}

class _JupggingInfo extends State<JupggingInfo> {
  var _icon = Icons.pause; //시작버튼
  var _color = Colors.grey; //버튼 색깔

  Timer _timer; //타이머
  var _time = 0;  //실제 늘어날 시간
  var _isPlaying = true; //시작/정지 상태

  Set<Marker>_markers = Set();
  Set<Polyline> lines = Set();
  List<LatLng> rpoints = List();

  @override
  void dispose() {
    _timer?.cancel();  //_timer가 null이 아니면 cancel() (null이면 아무것도 안함)
    super.dispose();
  }

  @override
  void initState() {
    _start();
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization(); //위치데이터를 읽어옴
  }

  @override
  Widget build(BuildContext context) {

    final dp = ModalRoute.of(context).settings.arguments as InfoLocation; //시작위치 받기
    LatLng departure = dp.start;//마크 출발점 찍기
    if(rpoints==null)
      rpoints.add(departure);
    print('departure point:  $departure');

    _markers.add(Marker( //시작위치 마커
        markerId: MarkerId("MyStartPosition"),
        position: LatLng(departure.latitude, departure.longitude),
        infoWindow: InfoWindow(title:'Start Position',snippet:'Start Running!!')
    ));

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
               child: _runningtime()  //시간 계산
        ),]
      ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(Alignment.center.x -0.2, Alignment.center.y+0.9),
            child: FloatingActionButton(
              onPressed: () => setState(() {
                _click();
              }),
              child: Icon(_icon),
              backgroundColor: _color,
            ),
          ),
          Align(
            alignment: Alignment(Alignment.center.x +0.4, Alignment.center.y+0.9),
            child: FloatingActionButton(
              onPressed: () {
                RunningInfo runinfo = new RunningInfo(minutes: _time~/60, seconds: _time%60);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JupggingEnd(run: runinfo))
                );
              },
              child: Icon(Icons.stop_rounded),
              backgroundColor: Colors.red,
            ),
          )
        ],
      )
    );
  }

  Widget googleMapUI () {
    return Consumer<LocationProvider>(builder: ( //changeNotifer가 변경될때마다 호촐
        consumerContext,
        model,
        child
        ) {
      if(model.locationPosition != null){
        LatLng end = LatLng(model.locationPosition.latitude,model.locationPosition.longitude);
        rpoints.add(end);

        lines.add(
          Polyline(
            points: rpoints,
            color: Colors.amber,
            polylineId: PolylineId("running route"),
          ),
        );


        return Column(
          children:[
            Expanded(
                child: GoogleMap(
                  mapType: MapType.normal,
                  markers: _markers,
                  polylines: lines,
                  initialCameraPosition: CameraPosition(
                      target: model.locationPosition,
                      zoom: 18
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (GoogleMapController controller){

                  })
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

  Widget _runningtime() {
    var sec = _time%60; //초
    var minute = _time ~/60; //분

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Stack(
          children: <Widget> [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget> [
                Text('0 km  ', style: TextStyle(fontSize: 30),),
                Text('$minute 분 ', style: TextStyle(fontSize: 30),),
                Text('$sec 초', style: TextStyle(fontSize: 30),),
              ]
            )
          ],
        ),
      ),
    );
  }

  void _click() {
    _isPlaying = !_isPlaying;

    if (_isPlaying) {
      _icon = Icons.pause;
      _color = Colors.grey;
      _start();
    } else {
      _icon = Icons.play_arrow;
      _color = Colors.amber;
      _pause();
    }
  }

    void _start() {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _time++;
        });
      });
    }
    void _pause() {
      _timer?.cancel();
    }

}