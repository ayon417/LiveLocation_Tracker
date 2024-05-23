import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_live_location/helper/base_view_model.dart';

final mapScreenViewModelProvider=ChangeNotifierProvider(
  (ref)=>MapScreenViewModel(ref: ref),
  
);
class MapScreenViewModel extends BaseViewModel{
    Ref ref;
    MapScreenViewModel({required this.ref});
    
    
    final Set<Marker> _markers = {};
    Set<Marker> get markers => _markers;

    final Set<Circle> _circle={};
    Set<Circle>? get circle=>_circle;

   LatLng? _currentPosition;
   LatLng? get currentPosition => _currentPosition;

   String _distance="";
   String get distance=>_distance;

    Stream<Position>? _positionStream;
    Stream<Position>? get positionStreamValue => _positionStream;

    
    //ignore: non_constant_identifier_names
    String google_api_key="AIzaSyAjdNnw06XH3bUkAB6VZBU3w7ynnvk1b5I";
    List<LatLng> polylineCoordinates = [];

    double? _sourceLatitude;
    double? get sourceLatitude=>_sourceLatitude;

    double? _sourceLongitude;
    double? get sourceLongitude=>_sourceLongitude;

    double? _destinationLatitude;
    double? get destinationLatitude=>_destinationLatitude;

    double? _destinationLongitude;
    double? get destinationLongitude=>_destinationLongitude;

    void setSource(List<Location> source){  
      _sourceLatitude=source.first.latitude;
      _sourceLongitude=source.first.longitude;
      notifyListeners();
    }
    void setDestination(List<Location> destination){
      _destinationLatitude=destination[0].latitude;
      _destinationLongitude=destination[0].longitude;
      notifyListeners();
   }
 void addMarker( LatLng positions, String locationTitle)
   {
    _markers.add(
      Marker(
       
      markerId: MarkerId(locationTitle),
      position: LatLng(positions.latitude, positions.longitude),
     ) );
     notifyListeners();
   }
   void moveCameraToPosition(GoogleMapController googleMapController,LatLng position,)
   {
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: 
    LatLng(position.latitude,position.longitude,),zoom: 14)),);
    notifyListeners();
   }
   void getPolyPoints(LatLng source, LatLng destination) async
    {
    polylineCoordinates.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(google_api_key,
    PointLatLng(source.latitude, source.longitude),
    PointLatLng(destination.latitude, destination.longitude));
    if(result.points.isNotEmpty)
    {
    for (var point in result.points) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }}
    notifyListeners();
    }

    void getCurrentPosition(GoogleMapController googleMapController)async
    {
      _positionStream = Geolocator.getPositionStream();
      _positionStream?.listen((Position position) {
      _currentPosition = LatLng(position.latitude, position.longitude);
       if(_currentPosition!=null)
      {
          _circle.add(
          Circle(
          circleId: CircleId('Your Location'),
          center: LatLng(currentPosition!.latitude,currentPosition!.longitude), // San Francisco coordinates
          radius: 60,
          fillColor: Color.fromARGB(255, 7, 100, 176).withOpacity(1),
          strokeWidth: 3,
          strokeColor: Colors.white,
        ),
      );



      //   _markers.add(
      //    Marker(
      //    zIndex: 2,
      //    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      //    markerId: const MarkerId("Current Location"),
      //    position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),

      //   ),
      // );
      if(googleMapController!=null)
      {
        moveCameraToPosition(googleMapController, LatLng(currentPosition!.latitude, currentPosition!.longitude),);
      }
      
       

    }});
   
    notifyListeners();
    }
  void getDistanceBetweenSourceAndDestination()
    {
      if(_sourceLatitude!=null && _sourceLongitude!=null && _destinationLatitude!=null && _destinationLongitude!=null)
      {
      double distanceInDouble=Geolocator.distanceBetween(_sourceLatitude!, _sourceLongitude!, _destinationLatitude!, _destinationLongitude!)/1000;
      _distance=distanceInDouble.toStringAsFixed(3);
      }
      
      notifyListeners();
    }

 }
   









