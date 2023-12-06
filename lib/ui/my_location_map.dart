/*
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:mapbox/ui/prepare_ride.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../utils/shared_prefs.dart';

class MyLocationMap extends StatefulWidget {
  const MyLocationMap({Key? key}) : super(key: key);

  @override
  State<MyLocationMap> createState() => _MyLocationMapState();
}

class _MyLocationMapState extends State<MyLocationMap> {
  // Waypoints to mark trip start and end
  LatLng source = getCurrentLatLngFromSharedPrefs();
  late WayPoint sourceWaypoint;
  var wayPoints = <WayPoint>[];

  // Config variables for Mapbox Navigation
  late MapBoxNavigation directions;
  late MapBoxOptions _options;
  late double? distanceRemaining, durationRemaining;
  late MapBoxNavigationViewController _controller;
  final bool isMultipleStop = false;
  String instruction = "";
  bool arrived = false;
  bool routeBuilt = false;
  bool isNavigating = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    if (!mounted) return;

    // Setup directions and options
    directions = MapBoxNavigation();
    directions.registerRouteEventListener((value) {
      _onRouteEvent(value);
    });
    _options = MapBoxOptions(
        zoom: 18.0,
        voiceInstructionsEnabled: false,
        bannerInstructionsEnabled: false,
        mode: MapBoxNavigationMode.drivingWithTraffic,
        isOptimized: false,
        units: VoiceUnits.metric,
        simulateRoute: false,
        showEndOfRouteFeedback: false,
        alternatives: false,
        showReportFeedbackButton: false,
        allowsUTurnAtWayPoints: false,
        animateBuildRoute: false,
        initialLatitude: source.latitude,
        initialLongitude: source.longitude,
        padding: const EdgeInsets.only(top: 120, bottom: 500, left: 150),
        language: "en");

    // Configure waypoints
    sourceWaypoint = WayPoint(name: "Source", latitude: source.longitude, longitude: source.longitude);
    wayPoints.add(sourceWaypoint);
    wayPoints.add(sourceWaypoint);
    setState(() {
      isLoading = false;

    });
    // Start the trip
    // await directions.startNavigation(wayPoints: wayPoints, options: _options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading?const SizedBox(): Container(
        color: Colors.grey,
        child: MapBoxNavigationView(
            options: _options,
            onRouteEvent: _onRouteEvent,
            onCreated:
                (MapBoxNavigationViewController controller) async {
              _controller = controller;
            }),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 28.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PrepareRide()));
              },
              child: const Icon(
                Icons.directions,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRouteEvent(e) async {
    distanceRemaining = await directions.getDistanceRemaining();
    durationRemaining = await directions.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        arrived = progressEvent.arrived!;
        if (progressEvent.currentStepInstruction != null) {
          instruction = progressEvent.currentStepInstruction!;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        arrived = true;
        if (!isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        routeBuilt = false;
        isNavigating = false;
        break;
      default:
        break;
    }
    //refresh UI
    setState(() {});
  }
}
*/
