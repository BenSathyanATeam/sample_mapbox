import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../utils/shared_prefs.dart';

 class TurnByTurn  {

  // Waypoints to mark trip start and end
  LatLng? source;
  LatLng? destination;
  late WayPoint sourceWaypoint, destinationWaypoint;
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


  Future<void> initialize() async {
    LatLng? source = getTripLatLngFromSharedPrefs('source');
    LatLng? destination = getTripLatLngFromSharedPrefs('destination');
    // Setup directions and options
    directions = MapBoxNavigation();
    directions.registerRouteEventListener((value) {
      _onRouteEvent(value);
    });
    _options = MapBoxOptions(
        zoom: 18.0,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        mode: MapBoxNavigationMode.drivingWithTraffic,
        isOptimized: true,
        units: VoiceUnits.metric,
        simulateRoute: false,
        language: "en");

    // Configure waypoints
    sourceWaypoint = WayPoint(name: "Source", latitude: source.latitude, longitude: source.longitude);
    destinationWaypoint =
        WayPoint(name: "Destination", latitude: destination.latitude, longitude: destination.longitude);
    wayPoints.add(sourceWaypoint);
    wayPoints.add(destinationWaypoint);

    // Start the trip
    await directions.startNavigation(wayPoints: wayPoints, options: _options);
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
      case MapBoxEvent.route_build_no_routes_found:
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
  }
}
