import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_live_location/screens/mapscreen_view_model.dart';
import 'package:google_map_live_location/screens/search_location_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState createState() => _MapScreenState();
}



class _MapScreenState extends ConsumerState<MapScreen> {
  @override
  void initState()
{
  super.initState();
  locationPermission();
   
}
// ignore: non_constant_identifier_names
  late Position position;
  late GoogleMapController googleMapController;
  PanelController panelController=PanelController();
 
  @override
  Widget build(BuildContext context) {
  MapScreenViewModel mapViewModel=ref.watch(mapScreenViewModelProvider);
   CameraPosition initialCameraPosition= CameraPosition(target: LatLng(mapViewModel.currentPosition?.latitude?? 26.516667,
   mapViewModel.currentPosition?.longitude?? 88.733333),zoom: 14);
 // Now, markers list contains only the markers with valid latitude and longitude values.
   return Scaffold(
        extendBodyBehindAppBar: true,
         appBar: PreferredSize(
           preferredSize: const Size.fromHeight(60),
           child: AppBar(
                title: const Text('Maps Sample App'), 
                backgroundColor: Colors.transparent.withOpacity(0.03),
              ),
         ),
        body: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0),
          child: SlidingUpPanel(
            controller: panelController,
            panelBuilder: (sc)
            {
            return SearchLocation(scrollController: sc,
            onTap: ()async
            {

            // To get Poly points //

            if(mapViewModel.sourceLatitude!=null && mapViewModel.sourceLongitude!=null && 
            mapViewModel.destinationLatitude!=null && mapViewModel.destinationLongitude!=null)
            {
                mapViewModel.getPolyPoints(LatLng( mapViewModel.sourceLatitude!, mapViewModel.sourceLongitude!), 
                LatLng(mapViewModel.destinationLatitude!, mapViewModel.destinationLongitude!));
            }
            // To show markers on the map //

             ref.read(mapScreenViewModelProvider).addMarker(LatLng(mapViewModel.sourceLatitude!, 
             mapViewModel.sourceLongitude!),
             "Source Location");
             
             ref.read(mapScreenViewModelProvider).addMarker(LatLng(mapViewModel.destinationLatitude!, 
             mapViewModel.destinationLongitude!),"Destination Location");

             mapViewModel.getDistanceBetweenSourceAndDestination();

            // To move camera to desired location //
              
              if(mapViewModel.sourceLatitude!=null && mapViewModel.sourceLongitude!=null &&
               mapViewModel.destinationLatitude!=null && mapViewModel.destinationLongitude!=null)
               {
              ref.read(mapScreenViewModelProvider).moveCameraToPosition(googleMapController,LatLng(mapViewModel.sourceLatitude!,
              mapViewModel.sourceLongitude!),);
               }
           },  
            );
            },
          
           body: Scaffold(
              extendBodyBehindAppBar: true,
              body: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              circles: mapViewModel.circle!,
              markers:mapViewModel.markers,
              mapType: MapType.normal,
              polylines: {
                Polyline(
                  polylineId:const PolylineId("route"),
                  points: mapViewModel.polylineCoordinates,
                  color: Colors.blue,
                  width: 5),
                },
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController googleMapController) {
                setState(() {
                  this.googleMapController=googleMapController;
                  ref.read(mapScreenViewModelProvider).getCurrentPosition(googleMapController);
                });
              }
              ),
              // floatingActionButton: Align(
              //   alignment: Alignment.topRight,
              //   child: Padding(
              //   padding: const EdgeInsets.only(top: 130),
              //     child: FloatingActionButton.extended(
              //       onPressed: (){
                   
              //         }, 
              //     icon: const Icon(Icons.location_on), label: const Text("Your Location")),
              //   ),
              // ),
              ),
          ),
        ),
      );
      
  
  }
  Future<Position> locationPermission() async { 
    bool serviceEnabled;

    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission=await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    else
    {
      Position position=await Geolocator.getCurrentPosition();
      
      
      return position;
    }
  }

 
}