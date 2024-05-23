import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class CircleScreen extends StatefulWidget {
  @override
  _CircleScreenState createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
 late GoogleMapController _controller;
  Set<Circle> _circles = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Circles Example'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // San Francisco coordinates
          zoom: 12,
        ),
        circles: _circles,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          _addCircles();
        },
      ),
    );
  }

  void _addCircles() {
    setState(() {
      _circles.add(
        Circle(
          circleId: CircleId('circle_1'),
          center: LatLng(37.7749, -122.4194), // San Francisco coordinates
          radius: 500,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeWidth: 2,
          strokeColor: Colors.blue,
        ),
      );
      _circles.add(
        Circle(
          circleId: CircleId('circle_2'),
          center: LatLng(37.7577, -122.4376), // Another location in San Francisco
          radius: 200,
          fillColor: Colors.red.withOpacity(0.3),
          strokeWidth: 2,
          strokeColor: Colors.red,
        ),
      );
    });
  }
}
