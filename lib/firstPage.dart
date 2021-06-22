import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jupgging/provider/location_provider.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  var _icon = Icons.play_arrow; //시작버튼
  var _color = Colors.amber; //버튼 색깔
  var _isStart = false;

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization(); //위치데이터를 읽어옴
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
            children: [
              //mapInfo((MediaQuery.of(context).size.height-50)*0.75),
              Container(  //지도 부분
                  color: Colors.lightGreen,
                  height: (MediaQuery.of(context).size.height-50)*0.75,
                  child:googleMapUI(),
                  ),
              Container(  //달린 거리, 시간 나오는 부분
                height: (MediaQuery.of(context).size.height-50)*0.25,
                color: Colors.white,
                child: Text("시작을 눌러주세요",textAlign: TextAlign.center,style:TextStyle(fontSize: 30)),  //시간 계산
              ),]
        ),
      ),
      bottomNavigationBar: BottomAppBar(  //네비게이션바
        child: Container(
          color: Colors.black12,
          height: 50,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          _click();
        }),
        child: Icon(_icon),
        backgroundColor: _color,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _click() {
    _isStart = !_isStart;

    if (_isStart) {
      Navigator.of(context)
          .pushReplacementNamed('/main/info',);
    }
  }

  Widget googleMapUI () {

    return Consumer<LocationProvider>(builder: ( //changeNotifer가 변경될때마다 호촐
        consumerContext,
        model,
        child
        ) {
          if(model.locationPosition != null){
            return Column(
              children:[
                Expanded(
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                          target: model.locationPosition,
                          zoom: 18
                      ),
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
