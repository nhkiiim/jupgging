import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jupgging/mapPage/firstPage.dart';
import 'package:jupgging/provider/location_provider.dart';
import 'dart:async';
import 'package:jupgging/mapPage/runningInfo.dart';
import 'package:jupgging/mapPage/jupggingEnd.dart';
import 'package:provider/provider.dart';
import 'dart:math' show cos, sqrt, asin;
import 'location.dart';

class JupggingInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _JupggingInfo();
}

class _JupggingInfo extends State<JupggingInfo> {
  var _icon = Icons.pause; //시작버튼
  var _color = Colors.grey; //버튼 색깔

  Timer _timer; //타이머
  var _time = 0; //실제 늘어날 시간
  var _isPlaying = true; //시작/정지 상태

  Set<Marker>_markers = Set();
  Set<Polyline> lines = Set();
  List<LatLng> rpoints = List();

  LatLng departure;
  LatLng dis_check;
  double distance; //거리
  int check;
  @override
  void dispose() {
    _timer?.cancel(); //_timer가 null이 아니면 cancel() (null이면 아무것도 안함)
    super.dispose();
  }

  @override
  void initState() {
    _start();
    super.initState();
    Provider.of<LocationProvider>(context, listen: false)
        .initialization(); //위치데이터를 읽어옴
    distance = 0.0;
    check=0;
  }

  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    final dp = ModalRoute.of(context).settings.arguments as InfoLocation; //시작위치 받기
    departure = dp.start; //출발점 위치
    if(check==0){
      dis_check = dp.start; //거리계산시작점
      check=1;
    }
    if (rpoints == null) rpoints.add(departure);

    _markers.add(Marker( //시작위치 마커
        markerId: MarkerId("MyStartPosition"),
        position: LatLng(departure.latitude, departure.longitude),
        infoWindow: InfoWindow(
            title: 'Start Position', snippet: 'Start Running!!')
    ));


    return Scaffold(
        body: Container(
          child: Column(
              children: [
                Container( //지도 부분
                    color: Colors.white,
                    height: screenHeight * 0.85,
                    child: Center(
                      child: googleMapUI(),
                    )
                ),
                Container( //달린 거리, 시간 나오는 부분
                    height: screenHeight * 0.15,
                    color: Colors.white,
                    child: _runningtime(screenHeight) //시간 계산
                ),
              ]
          ),
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(
                  Alignment.center.x - 0.2, Alignment.center.y + 1.0),
              child: SizedBox(
                height: screenHeight * 0.15 * 0.4,
                child: FloatingActionButton(
                  onPressed: () =>
                      setState(() {
                        _click();
                      }),
                  child: Icon(_icon),
                  backgroundColor: _color,
                ),
              ),
            ),
            Align(
                alignment: Alignment(
                    Alignment.center.x + 0.4, Alignment.center.y + 1.0),
                child: SizedBox(
                  height: screenHeight * 0.15 * 0.4,
                  child: FloatingActionButton(
                    onPressed: () {
                      _pause();
                      RunningInfo runinfo = new RunningInfo(
                          minutes: _time ~/ 60, seconds: _time % 60);
                      Navigator.of(context)
                          .pushReplacementNamed('/main/info/end',
                          arguments: JupggingEnd(run: runinfo,
                              route: rpoints,
                              departure: departure,
                              distance: distance));
                    },
                    child: Icon(Icons.stop_rounded),
                    backgroundColor: Colors.red,
                  ),
                )
            ),
          ],
        )
    );
  }

  Widget googleMapUI() {
    return Consumer<LocationProvider>(builder: (consumerContext,
        model,
        child) {
      if (model.locationPosition != null) {
        //현재위치
        LatLng current_location = LatLng(
            model.locationPosition.latitude, model.locationPosition.longitude);
        rpoints.add(current_location);

        //polyline point추가
        lines.add(
          Polyline(
            points: rpoints,
            color: Colors.amber,
            polylineId: PolylineId("running route"),
          ),
        );

        //거리계산
        if (dis_check != model.locationPosition) {
          var dis = double_coordinateDistance(
              dis_check.latitude, dis_check.longitude,
              model.locationPosition.latitude,
              model.locationPosition.longitude);
          distance += dis;
          distance = double.parse(distance.toStringAsFixed(2)); //소수점 한자리

        }
        dis_check = model.locationPosition;

        return Column(
          children: [
            Expanded(
                child: GoogleMap(
                    mapType: MapType.normal,
                    markers: _markers,
                    polylines: lines,
                    initialCameraPosition: CameraPosition(
                        target: model.locationPosition,
                        zoom: 17
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onMapCreated: (GoogleMapController controller) async{
                      Provider.of<LocationProvider>(context,listen:false)
                          .setMapController(controller);
                    })
            )
          ],
        );
      }

      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  Widget _runningtime(dynamic screenHeight) {
    var sec = _time % 60; //초
    var minute = _time ~/ 60; //분

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Stack(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('$distance km  ',
                    style: TextStyle(fontSize: screenHeight * 0.03),),
                  Text('$minute 분 ',
                    style: TextStyle(fontSize: screenHeight * 0.03),),
                  Text(
                    '$sec 초', style: TextStyle(fontSize: screenHeight * 0.03),),
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

  //거리계산공식
  double_coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var dis = 12742 * asin(sqrt(a));
    //print(dis);
    return dis;
  }


}