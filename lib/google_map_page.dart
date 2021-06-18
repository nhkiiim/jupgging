import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jupgging/provider/location_provider.dart';
import 'package:jupgging/main.dart';
import 'package:map_polyline_draw/map_polyline_draw.dart';
import 'package:provider/provider.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key key}) : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization(); //위치데이터를 읽어옴
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Google Map Live Tracking"),
        backgroundColor: Colors.redAccent,
      ),
      body: googleMapUI(),
    );
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
