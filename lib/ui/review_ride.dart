import 'package:flutter/material.dart';
import 'package:mapbox/ui/turn_by_turn.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../utils/drop_off_time.dart';
import '../utils/shared_prefs.dart';
import '../widgets/review_ride_bottom_sheet.dart';
import 'map_view.dart';

class ReviewRide extends StatefulWidget {
  final Map modifiedResponse;
  const ReviewRide({Key? key, required this.modifiedResponse})
      : super(key: key);

  @override
  State<ReviewRide> createState() => _ReviewRideState();
}

class _ReviewRideState extends State<ReviewRide> {
  // Mapbox Maps SDK related
  final List<CameraPosition> _kTripEndPoints = [];
  late MapboxMapController controller;
  TurnByTurn turnByTurn = TurnByTurn();
  // Directions API response related
  late String distance;
  late String dropOffTime;
  late Map geometry;

  @override
  void initState() {
    // initialise distance, dropOffTime, geometry
    _initialiseDirectionsResponse();

    // initialise initialCameraPosition, address and trip end points
//    _initialCameraPosition = CameraPosition(target: getCenterCoordinatesForPolyline(geometry), zoom: 11);

    for (String type in ['source', 'destination']) {
      _kTripEndPoints.add(CameraPosition(target: getTripLatLngFromSharedPrefs(type)));
    }
    super.initState();
  }

  _initialiseDirectionsResponse() {
    distance = (widget.modifiedResponse['distance'] / 1000).toStringAsFixed(1);
    dropOffTime = getDropOffTime(widget.modifiedResponse['duration']);
    geometry = widget.modifiedResponse['geometry'];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Review Ride'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const MapViewScreen(),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(onTap:(){
                  turnByTurn.initialize();
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> const TurnByTurn()));

                },child: reviewRideBottomSheet(context, distance, dropOffTime)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
