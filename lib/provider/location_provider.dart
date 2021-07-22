import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier{

  GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;

  Location _location;
  Location get location => _location;
  LatLng _locationPosition;
  LatLng get locationPosition => _locationPosition;

  bool locationServiceActive = true;

  LocationProvider() {
    _location = new Location();
  }

  initialization() async{
    await getUserLocation();
  }

  getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled){
      _serviceEnabled = await location.requestService();

      if(!_serviceEnabled){
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.GRANTED){
        return;
      }
    }

    location.onLocationChanged().listen((LocationData currentLocation){

      _locationPosition = LatLng(
            currentLocation.latitude,
            currentLocation.longitude
        );

      setMapController(_mapController);
        //print(_locationPosition);
      notifyListeners();
    });
  }

  setMapController(GoogleMapController controller)async{
    _mapController=controller;
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: _locationPosition,
            zoom:17
        )
    ));
  }
}