import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jupgging/provider/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:jupgging/mapPage/location.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with SingleTickerProviderStateMixin {

  InfoLocation st= new InfoLocation();
  TabController controller;

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
      body:
      Container(
        child: Column(
            children: [
              //mapInfo((MediaQuery.of(context).size.height-50)*0.75),
              Container(  //지도 부분
                  color: Colors.white,
                  height: (MediaQuery.of(context).size.height-50)*0.85,
                  child:googleMapUI(),               ),
              Container(  //달린 거리, 시간 나오는 부분
                height: (MediaQuery.of(context).size.height-50)*0.15,
                color: Colors.white,
                child: Text("시작을 눌러주세요",textAlign: TextAlign.center,style:TextStyle(fontSize: 20)),  //시간 계산
              ),]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          _isStart = !_isStart;

          if (_isStart) {
            Navigator.of(context)
                .pushReplacementNamed('/main/info',arguments: InfoLocation(start:st.start));
          }
        }),
        child: Icon(_icon),
        backgroundColor: _color,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget googleMapUI () {
    return Consumer<LocationProvider>(builder: ( //changeNotifer가 변경될때마다 호촐
        consumerContext,
        model,
        child
        ) {
      if(model.locationPosition != null){
        st.start=model.locationPosition;
        print('위치 ${st.start}');
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
